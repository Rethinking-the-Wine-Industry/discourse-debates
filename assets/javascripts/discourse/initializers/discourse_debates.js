import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "debate-stance-class-decorator",

  initialize() {
    withPluginApi((api) => {
      api.addPostClassesCallback((post) => {
        const stance = post.current_user_stance;

        if (stance) {
          return ["discourse-debates", `stance-${stance}`];
        }

        return [];
      });
    });
  },
};
