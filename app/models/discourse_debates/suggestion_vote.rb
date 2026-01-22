# frozen_string_literal: true

module DiscourseDebates
  class SuggestionVote < ActiveRecord::Base
    self.table_name = "discourse_debates_suggestion_votes"

    belongs_to :user
    belongs_to :topic

    validates :topic_id, presence: true
    validates :user_id, presence: true
    validates :user_id, uniqueness: { scope: :topic_id }
  end
end
