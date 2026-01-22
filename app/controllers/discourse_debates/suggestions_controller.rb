# frozen_string_literal: true

module DiscourseDebates
  class SuggestionsController < ::ApplicationController
    requires_plugin "discourse-debates"

    before_action :ensure_logged_in

    def vote
      topic = Topic.find(params[:topic_id])

      unless suggestion_box_topic?(topic)
        return render json: { error: "invalid_category" }, status: 422
      end

      DiscourseDebates::SuggestionVote.create!(
        topic_id: topic.id,
        user_id: current_user.id
      )

      render json: {
        votes: votes_count(topic),
        voted: true
      }
    rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid
      render json: { error: "already_voted" }, status: 422
    end

    private

    def suggestion_box_topic?(topic)
      suggestion_category_id = SiteSetting.discourse_debates_suggestion_category_id
      topic.category_id == suggestion_category_id
    end

    def votes_count(topic)
      DiscourseDebates::SuggestionVote.where(topic_id: topic.id).count
    end
  end
end
