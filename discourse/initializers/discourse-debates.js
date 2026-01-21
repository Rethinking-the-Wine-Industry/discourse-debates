import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "discourse-debates",
  initialize() {
    withPluginApi("1.9.0", (api) => {
      if (!api.getCurrentUser()) return;
      if (!api.siteSettings?.debate_enabled) return;

      // frontend será conectado nos próximos passos
    });
  },
};
