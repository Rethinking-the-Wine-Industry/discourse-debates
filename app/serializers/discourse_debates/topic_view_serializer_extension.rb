module DiscourseDebates
  module TopicViewSerializerExtension
    def self.prepended(base)
      base.attributes :debate_suggestion
    end

    def debate_suggestion
      return nil unless suggestion_topic?

      votes = DiscourseDebates::SuggestionVote
        .where(topic_id: object.topic.id)

      {
        user_vote: user_vote_for_topic,
        counts: {
          yes: votes.yes.count,
          no: votes.no.count,
        },
      }
    end

    private

    def suggestion_topic?
      # ajuste isso para a sua lógica real
      object.topic.category&.slug == "suggestion-box"
    end

    def user_vote_for_topic
      return nil unless scope.user

      vote = DiscourseDebates::SuggestionVote.find_by(
        topic_id: object.topic.id,
        user_id: scope.user.id
      )

      vote&.vote
    end
  end
end
