# frozen_string_literal: true

module DiscourseDebates
  module TopicViewSerializerExtension
    def self.prepended(base)
      base.attributes(:debate_suggestion, :debate, :debate_stance, :debate_stance_counts)
    end

    ### --------------------
    ### SUGGESTION
    ### --------------------

    def debate_suggestion
      topic = object.topic
      return nil unless suggestion_topic?(topic)

      votes = DiscourseDebates::SuggestionVote.where(topic_id: topic.id).group(:vote).count

      { counts: { yes: votes["yes"] || 0, no: votes["no"] || 0 }, user_vote: user_vote(topic) }
    end

    def include_debate_suggestion?
      debate_suggestion.present?
    end

    ### --------------------
    ### DEBATE
    ### --------------------

    def debate
      return nil unless object.topic.custom_fields["is_debate"]

      { user_stance: debate_stance, counts: debate_stance_counts }
    end

    def include_debate?
      object.topic.custom_fields["is_debate"]
    end

    def debate_stance
      return nil unless scope.user

      DiscourseDebates::StanceManager.user_stance(topic: object.topic, user: scope.user)
    end

    def include_debate_stance?
      object.topic.custom_fields["is_debate"] && scope.user.present?
    end

    def debate_stance_counts
      DiscourseDebates::StanceManager.counts_for(object.topic)
    end

    def include_debate_stance_counts?
      object.topic.custom_fields["is_debate"]
    end

    ### --------------------
    ### HELPERS
    ### --------------------

    private

    def suggestion_topic?(topic)
      topic.category_id == SiteSetting.discourse_debates_suggestion_category_id
    end

    def user_vote(topic)
      return nil unless scope.user

      DiscourseDebates::SuggestionVote.find_by(topic_id: topic.id, user_id: scope.user.id)&.vote
    end
  end
end
