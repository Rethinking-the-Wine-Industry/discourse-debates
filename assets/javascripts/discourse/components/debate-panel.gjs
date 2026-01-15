import Component from "@glimmer/component";
import { action } from "@ember/object";
import { tracked } from "@glimmer/tracking";
import { inject as service } from "@ember/service";
import { on } from "@ember/modifier";
import { fn } from "@ember/helper";
import ajax from "discourse/lib/ajax";

export default class DebatePanel extends Component {
  @service currentUser;

  @tracked stance = null;
  @tracked isSaving = false;
  @tracked counts = null;
  @tracked isLoadingCounts = true;

  get topic() {
    return this.args.topic;
  }

  get canVote() {
    return this.currentUser && this.topic;
  }

  constructor() {
    super(...arguments);
    this.loadCounts();
  }

  async loadCounts() {
    if (!this.topic) return;

    this.isLoadingCounts = true;

    try {
      this.counts = await ajax(
        `/debate/counts/${this.topic.id}`
      );
    } finally {
      this.isLoadingCounts = false;
    }
  }

  @action
  selectStance(value) {
    this.stance = value;
  }

  @action
  async saveStance() {
    if (!this.stance || !this.topic) return;

    this.isSaving = true;

    try {
      await ajax(`/debate/stance`, {
        type: "POST",
        data: {
          topic_id: this.topic.id,
          stance: this.stance,
        },
      });

      await this.loadCounts();
    } finally {
      this.isSaving = false;
    }
  }

  <template>
    <div class="debate-panel">
      <h3 class="debate-panel__title">
        Do you agree with this hypothesis?
      </h3>

      {{#if this.canVote}}
        <form class="debate-panel__options">
          <label>
            <input
              type="radio"
              name="debate-stance"
              {{on "change" (fn this.selectStance "favor")}}
            />
            For
          </label>

          <label>
            <input
              type="radio"
              name="debate-stance"
              {{on "change" (fn this.selectStance "neutral")}}
            />
            Neutral
          </label>

          <label>
            <input
              type="radio"
              name="debate-stance"
              {{on "change" (fn this.selectStance "against")}}
            />
            Against
          </label>

          <button
            type="button"
            class="btn btn-primary"
            disabled={{this.isSaving}}
            {{on "click" this.saveStance}}
          >
            {{#if this.isSaving}}Saving…{{else}}Submit{{/if}}
          </button>
        </form>
      {{else}}
        <p>Please log in to participate.</p>
      {{/if}}

      <hr />

      {{#if this.isLoadingCounts}}
        <p>Loading results…</p>
      {{else if this.counts}}
        <div class="debate-panel__counts">
          <div>For: <strong>{{this.counts.favor}}</strong></div>
          <div>Neutral: <strong>{{this.counts.neutral}}</strong></div>
          <div>Against: <strong>{{this.counts.against}}</strong></div>
          <div>Total votes: {{this.counts.total}}</div>
        </div>
      {{/if}}
    </div>
  </template>
}
