import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "debate",
  initialize() {
    withPluginApi("1.9.0", (api) => {
      api.renderAfterWrapperOutlet(
        "topic-navigation",
        class extends Component {
          static shouldRender(args) {
            const post = args.post;
            const stance = post.topic_user_custom_fields?.debate_stance;
            if (!stance) return;
            const label = {
              favor: "For",
              neutral: "Neutral",
              against: "Against",
            }[stance];
            return helper.h("span.debate-badge", label);
          }
        }
      );

      api.registerSidebarPanel("debate-panel", {
        title: "Do you agree with this hypothesis?",
        icon: "balance-scale",
        component: "debate-panel",
      });
    });
  },
};
