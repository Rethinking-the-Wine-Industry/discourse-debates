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

      vote_value =
        case params[:vote]
        when "yes" then 1
        when "no" then -1
        else
            return render json: { error: "invalid_vote" }, status: 422
        end

      DiscourseDebates::SuggestionVote.create!(
        topic_id: topic.id,
        user_id: current_user.id,
        vote: vote_value
      )

      render json: votes_summary(topic)
    rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid
      render json: { error: "already_voted" }, status: 422
    end

    private

    def suggestion_box_topic?(topic)
      suggestion_category_id = SiteSetting.discourse_debates_suggestion_category_id
      topic.category_id == suggestion_category_id
    end

    def votes_summary(topic)
    votes = DiscourseDebates::SuggestionVote.where(topic_id: topic.id)

    {
        yes: votes.where(vote: 1).count,
        no: votes.where(vote: -1).count,
        total: votes.count,
        user_vote: votes.find_by(user_id: current_user.id)&.vote
    }
    end
  end
end
