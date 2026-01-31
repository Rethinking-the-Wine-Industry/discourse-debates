import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { Input } from "@ember/component";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { ajax } from "discourse/lib/ajax";

export default class DebateSuggestionTester extends Component {
  @tracked topicId = "";
  @tracked result = null;
  @tracked loading = false;

  @action
  async promote() {
    this.loading = true;
    this.result = null;

    try {
      const res = await ajax("/debates/admin/suggestions/promote", {
        type: "POST",
        data: { topic_id: this.topicId },
      });

      this.result = res;
    } catch (e) {
      this.result = {
        success: false,
        message: e?.jqXHR?.responseJSON?.errors?.[0],
      };
    } finally {
      this.loading = false;
    }
  }

  <template>
    <div class="debate-suggestion-tester">
      <h3>Manual suggestion promotion</h3>

      <Input @value={{this.topicId}} placeholder="Topic ID" @type="number" />

      <button
        class="btn btn-primary"
        disabled={{this.loading}}
        {{on "click" this.promote}}
      >
        {{if this.loading "Processing…" "Try promote"}}
      </button>

      {{#if this.result}}
        <p class={{if this.result.success "success" "error"}}>
          {{this.result.message}}
        </p>
      {{/if}}
    </div>
  </template>
}
