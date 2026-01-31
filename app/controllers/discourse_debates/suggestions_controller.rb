# frozen_string_literal: true
#
module DiscourseDebates
  class SuggestionsController < ::ApplicationController
    requires_plugin "discourse-debates"
    before_action :ensure_logged_in

    def vote
      topic = Topic.find(params[:topic_id])

      vote_value = params.require(:vote)
      return render_json_error("invalid_vote") unless %w[yes no].include?(vote_value)

      suggestion_vote =
        DiscourseDebates::SuggestionVote.find_or_initialize_by(
          topic_id: topic.id,
          user_id: current_user.id,
        )

      suggestion_vote.vote = vote_value
      suggestion_vote.save!

      render json: { vote: suggestion_vote.vote, counts: vote_counts_for(topic) }
    rescue ActiveRecord::RecordInvalid => e
      render_json_error(e.record.errors.full_messages.join(", "))
    end

    private

    def vote_counts_for(topic)
      votes = DiscourseDebates::SuggestionVote.where(topic_id: topic.id)

      { yes: votes.yes.count, no: votes.no.count }
    end
  end
end
