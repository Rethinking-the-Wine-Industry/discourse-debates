import Component from "@glimmer/component";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";

export default class SuggestionYesNoVote extends Component {
  @service currentUser;
  @service siteSettings;

  get topic() {
    return this.args.outletArgs?.topic;
  }

  get isEnabled() {
    return this.siteSettings.discourse_debates_enabled;
  }

  get isSuggestionBox() {
    return (
      this.topic &&
      this.topic.category_id ===
        this.siteSettings.discourse_debates_suggestion_category_id
    );
  }

  get votes() {
    return this.topic.custom_fields?.suggestion_votes || {
      yes: 0,
      no: 0,
    };
  }

  get userVote() {
    return this.topic.custom_fields?.user_vote;
  }

  get canVote() {
    return this.currentUser && !this.userVote;
  }

  @action
  async vote(value) {
    try {
      const result = await ajax(
        `/debates/suggestions/${this.topic.id}/vote`,
        {
          type: "POST",
          data: { vote: value },
        }
      );

      this.topic.custom_fields ||= {};
      this.topic.custom_fields.suggestion_votes = {
        yes: result.yes,
        no: result.no,
      };
      this.topic.custom_fields.user_vote = result.user_vote;
    } catch (e) {
      console.error("Vote failed", e);
    }
  }

  <template>
    {{#if (and this.isEnabled this.isSuggestionBox)}}
      <div class="debate-suggestion-vote">
        <div class="question">
          Do you think this issue should be open for debate?
        </div>

        <div class="buttons">
          <DButton
            @icon="thumbs-up"
            @label={{concat "Yes (" this.votes.yes ")"}}
            @action={{fn this.vote "yes"}}
            @disabled={{not this.canVote}}
            class="btn-primary"
          />

          <DButton
            @icon="thumbs-down"
            @label={{concat "No (" this.votes.no ")"}}
            @action={{fn this.vote "no"}}
            @disabled={{not this.canVote}}
            class="btn-danger"
          />
        </div>

        {{#if this.userVote}}
          <div class="user-vote">
            You voted:
            <strong>
              {{if (eq this.userVote 1) "Yes" "No"}}
            </strong>
          </div>
        {{/if}}
      </div>
    {{/if}}
  </template>
}
