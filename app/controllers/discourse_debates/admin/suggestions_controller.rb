# frozen_string_literal: true

module DiscourseDebates
  module Admin
    class SuggestionsController < ::Admin::AdminController
      requires_plugin "discourse-debates"

      def promote
        topic = Topic.find_by(id: params[:topic_id])

        return render_json_error("Topic not found") unless topic

        result = DiscourseDebates::SuggestionPromoter.call(topic, force: true)

        if result.success?
          render json: { success: true, message: result.message }
        else
          render json: { success: false, message: result.message }
        end
      end
    end
  end
end
