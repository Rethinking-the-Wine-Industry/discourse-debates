import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "discourse-debates-suggestion-vote",

  initialize() {
    withPluginApi("1.9.0", (api) => {
      api.renderInOutlet(
        "topic-navigation",
        "suggestion-yes-no-vote"
      );
    });
  },
};
