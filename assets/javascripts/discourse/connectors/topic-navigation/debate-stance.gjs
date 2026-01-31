import Component from "@glimmer/component";
import DebateStancePicker from "../../components/debate-stance-picker";

export default class DebateStanceConnector extends Component {
  get topic() {
    return this.args.outletArgs.topic;
  }

  get debate() {
    return this.topic.debate;
  }

  get enabled() {
    return !!this.debate;
  }

  get userStance() {
    return this.debate?.user_stance;
  }

  <template>
    <DebateStancePicker
      @topic={{this.topic}}
      @stance={{this.userStance}}
      @enabled={{this.enabled}}
    />
  </template>
}
