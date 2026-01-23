import Component from "@glimmer/component";
import { action } from "@ember/object";
import { ajax } from "discourse/lib/ajax";

export default class DebateSuggestion extends Component {
  get suggestion() {
    return this.args.outletArgs?.topicView?.debate_suggestion;
  }

  get counts() {
    return this.suggestion?.counts;
  }

  get userVote() {
    return this.suggestion?.user_vote;
  }

  get shouldRender() {
    return !!this.suggestion;
  }

  @action
  vote(value) {
    if (!this.args.outletArgs?.topic) {
      return;
    }

    ajax(
      `/debates/suggestions/${this.args.outletArgs.topic.id}/vote`,
      {
        type: "POST",
        data: { vote: value },
      }
    ).then((result) => {
      // Atualiza o estado local sem reload
      this.suggestion.user_vote = result.vote;
      this.suggestion.counts = result.counts;
    });
  }

  <template>
    {{#if this.shouldRender}}
      <div class="debate-suggestion-panel">
        <p class="question">
          Do you think this issue should be open for debate?
        </p>

        <div class="votes">
          <button
            class={{concat "vote yes " (if (eq this.userVote "yes") "active")}}
            {{on "click" (fn this.vote "yes")}}
          >
            👍 Yes ({{this.counts.yes}})
          </button>

          <button
            class={{concat "vote no " (if (eq this.userVote "no") "active")}}
            {{on "click" (fn this.vote "no")}}
          >
            👎 No ({{this.counts.no}})
          </button>
        </div>
      </div>
    {{/if}}
  </template>
}
