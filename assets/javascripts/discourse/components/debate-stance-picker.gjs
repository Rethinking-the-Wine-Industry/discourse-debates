import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { ajax } from "discourse/lib/ajax";

export default class DebateStancePicker extends Component {
  @tracked loading = false;
  @tracked
  stance =
    this.args.topic.debate_stance || this.args.topic.topic_view?.debate_stance;

  constructor() {
    super(...arguments);
  }

  get topic() {
    return this.args.topic;
  }

  get enabled() {
    return this.args.is_debate;
  }

  @action
  async select(value) {
    console.log("outletArgs? ", this.args.topic);

    if (this.loading || this.stance === value) {
      return;
    }
    this.loading = true;
    try {
      await ajax(`/debates/${this.topic.id}/stance`, {
        type: "POST",
        data: { stance: value },
      });
      this.stance = value;
      this.topic.set("debate_stance", value);
    } finally {
      this.loading = false;
    }
  }

  @action
  stanceClass(value) {
    console.log("[stanceClass] value: ", value);
    return this.stance === value ? "active" : "";
  }

  <template>
    {{!-- {{#if this.enabled}} --}}
    <div class="debate-stance-picker">
      <p class="question">Do you agree with this hypothesis?</p>
      {{!-- <p class="question">enabled? {{this.enabled}}</p> --}}
      <p class="question">Current Stance: {{this.stance}}</p>
      <div class="segmented-control">
        <button
          class={{fn this.stanceClass "for"}}
          {{!-- disabled={{this.loading}} --}}
          {{on "click" (fn this.select "for")}}
        >
          For
        </button>

        <button
          class={{fn this.stanceClass "neutral"}}
          {{!-- disabled={{this.loading}} --}}
          {{on "click" (fn this.select "neutral")}}
        >
          Neutral
        </button>

        <button
          class={{fn this.stanceClass "against"}}
          {{!-- disabled={{this.loading}} --}}
          {{on "click" (fn this.select "against")}}
        >
          Against
        </button>
      </div>
    </div>
    {{!-- {{/if}} --}}
  </template>
}
