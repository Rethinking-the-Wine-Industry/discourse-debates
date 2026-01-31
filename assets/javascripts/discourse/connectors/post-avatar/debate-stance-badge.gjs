import Component from "@glimmer/component";

export default class DebateStanceBadge extends Component {
  get stance() {
    return this.args.outletArgs?.post?.topic_user_custom_fields?.debate_stance;
  }

  get label() {
    return {
      for: "For",
      neutral: "Neutral",
      against: "Against",
    }[this.stance];
  }

  <template>
    {{#if this.label}}
      <span class="debate-stance-badge {{this.stance}}">
        {{this.label}}
      </span>
    {{/if}}
  </template>
}
