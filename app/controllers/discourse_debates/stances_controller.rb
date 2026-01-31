# frozen_string_literal: true
#
module DiscourseDebates
  class StancesController < ::ApplicationController
    requires_plugin "discourse-debates"

    before_action :ensure_logged_in

    def set
      params.require(%i[topic_id stance])

      topic_id = params[:topic_id].to_i
      stance_value = params[:stance]

      # Verificamos se o model existe antes de chamar (debug útil)
      unless defined?(::DiscourseDebates::Stance)
        return render json: { error: "Model Stance não carregado corretamente" }, status: 500
      end

      stance =
        ::DiscourseDebates::Stance.find_or_initialize_by(
          topic_id: topic_id,
          user_id: current_user.id,
        )

      stance.stance = stance_value

      if stance.save
        render json: { success: "OK", stance: stance.stance, topic_id: topic_id }
      else
        render_json_error(stance)
      end
    rescue ArgumentError
      render json: { error: "Valor de stance inválido" }, status: 400
    end
  end
end

# module DiscourseDebates
#   class StancesController < ::ApplicationController
#     requires_plugin "discourse-debates"
#     before_action :ensure_logged_in

#     def set
#       params.require(:topic_id)
#       params.require(:stance)

#       topic = Topic.find(params[:topic_id].to_i)
#       guardian.ensure_can_see!(topic)

#       result = setstance(topic: topic, user: current_user, stance: params[:stance])

#       render json: MultiJson.dump(result)
#     end

#     private

#     def setstance(topic:, user:, stance:)
#       raise Discourse::InvalidAccess unless user

#       stance = stance.to_s

#       stance =
#         DiscourseDebates::Stance.find_or_initialize_by(topic_id: topic_id, user_id: current_user.id)

#       stance.stance = stance_value

#       if stance.save
#         render json: success_json
#       else
#         render_json_error(stance)
#       end
#     end
#   end
# end
