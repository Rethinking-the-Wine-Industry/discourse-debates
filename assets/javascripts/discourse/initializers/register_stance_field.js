// assets/javascripts/discourse/initializers/fix-stance.js
import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "fix-stance",
  initialize() {
    withPluginApi((api) => {
      // Força o Ember a reconhecer a propriedade no model
      api.modifyClass("model:topic", {
        pluginId: "discourse-debates",
        updateFromSerializer(payload) {
          this._super(...arguments); // Mantém o comportamento padrão do Discourse

          if (payload.debate_stance) {
            // Injeta o valor na raiz do model para ser acessível via this.args.topic.debate_stance
            this.set("debate_stance", payload.debate_stance);
          }
        },
      });
    });
  },
};
