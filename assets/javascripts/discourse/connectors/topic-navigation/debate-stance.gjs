import Component from "@glimmer/component";
import DebateStancePicker from "../../components/debate-stance-picker";

export default class DebateStanceConnector extends Component {
  get topic() {
    return this.args.outletArgs.topic;
  }

  <template><DebateStancePicker @topic={{this.topic}} /></template>
}
