import Component from "@glimmer/component";
import SuggestionYesNoVote from "../../components/suggestion-yes-no-vote";

export default class SuggestionConnector extends Component {
  get topic() {
    return this.args.topic;
  }

  <template><SuggestionYesNoVote @topic={{this.topic}} /></template>
}
