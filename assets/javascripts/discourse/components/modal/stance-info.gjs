import Component from "@glimmer/component";
import { action } from "@ember/object";
import DButton from "discourse/components/d-button";
import DModal from "discourse/components/d-modal";
import icon from "discourse/helpers/d-icon";

export default class StanceInfoModal extends Component {
  get stances() {
    return this.args.model.stance_count;
  }

  @action
  close() {
    this.args.closeModal();
  }

  <template>
    <DModal
      @title="Overview"
      @closeModal={{@closeModal}}
      class="discourse-debates-modal stance-info"
    >
      <:body>
        <h5 class="stance-info__title">
          Current Votes
        </h5>

        <ul class="stance-info__list">
          <li class="stance-info__list-item">
            <span class="discourse-debates__icon for">{{icon
                "wine-glass"
              }}</span>
            <span class="stance-info__name">For</span>
            <span class="stance-info__number">{{this.stances.for}}</span>
          </li>
          <li class="stance-info__list-item">
            <span class="discourse-debates__icon neutral">{{icon
                "minus"
              }}</span>
            <span class="stance-info__name">Neutral</span>
            <span class="stance-info__number">{{this.stances.neutral}}</span>
          </li>
          <li class="stance-info__list-item">
            <span class="discourse-debates__icon against">{{icon
                "wine-glass"
              }}</span>
            <span class="stance-info__name">Against</span>
            <span class="stance-info__number">{{this.stances.against}}</span>
          </li>
        </ul>
      </:body>

      <:footer>
        <DButton @label="close" @action={{this.close}} />
      </:footer>
    </DModal>
  </template>
}
