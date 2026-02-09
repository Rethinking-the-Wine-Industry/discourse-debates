import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import icon from "discourse/helpers/d-icon";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default class SuggestionYesNoVote extends Component {
  @tracked loading = false;
  @tracked current_user_vote = null;
  @tracked suggestion_vote_count = null;

  constructor() {
    super(...arguments);
    this.current_user_vote = this.topic.current_user_vote;
    this.suggestion_vote_count = this.topic.suggestion_vote_count || {
      yes: 0,
      no: 0,
    };
  }

  get topic() {
    return this.args.topic;
  }

  get enabled() {
    return this.topic.is_suggestion;
  }

  get canVote() {
    return !this.current_user_vote;
  }

  get yesLabel() {
    return `Yes (${this.suggestion_vote_count.yes})`;
  }

  get noLabel() {
    return `No (${this.suggestion_vote_count.no})`;
  }

  get isYes() {
    return this.current_user_vote === "yes" || this.current_user_vote === 1;
  }

  get isNo() {
    return this.current_user_vote === "no" || this.current_user_vote === -1;
  }

  get yesClass() {
    return this.isYes ? "active" : "";
  }

  get noClass() {
    return this.isNo ? "active" : "";
  }

  get userVoteLabel() {
    if (this.isYes) {
      return "Yes";
    }
    if (this.isNo) {
      return "No";
    }
    return null;
  }

  @action
  voteYes() {
    this.submitVote("yes");
  }

  @action
  voteNo() {
    this.submitVote("no");
  }

  async submitVote(value) {
    if (!this.topic) {
      return;
    }

    try {
      this.loading = true;
      const result = await ajax(`/debates/suggestions/${this.topic.id}`, {
        type: "POST",
        data: { vote: value },
      });

      this.current_user_vote = result.vote;
      this.suggestion_vote_count = result.counts;
    } catch (e) {
      popupAjaxError(e);
    } finally {
      this.loading = false;
    }
  }

  <template>
    {{#if this.enabled}}
      <div class="debate-suggestion-panel debate-suggestion-vote">
        <h4 class="question">
          Do you think this issue should be open for debate?
        </h4>

        <div class="votes">
          <button
            disabled={{this.loading}}
            class="btn btn-default {{this.yesClass}}"
            {{on "click" (fn this.voteYes)}}
          >
            <span class="discourse-debates__icon">
              {{icon "wine-glass"}}
            </span>
            {{this.yesLabel}}
          </button>

          <button
            disabled={{this.loading}}
            class="btn btn-default {{this.noClass}}"
            {{on "click" (fn this.voteNo)}}
          >
            <span class="discourse-debates__icon against">
              {{icon "wine-glass"}}
            </span>
            {{this.noLabel}}</button>
        </div>
      </div>
    {{/if}}
  </template>
}
