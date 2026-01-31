# frozen_string_literal: true
#
module DiscourseDebates
  class StanceManager
    def self.set(topic:, user:, stance:)
      raise Discourse::InvalidAccess unless user

      stance = stance.to_s
      raise ArgumentError unless DiscourseDebates::Stance.stances.key?(stance)

      record = DiscourseDebates::Stance.find_or_create_by(topic_id: topic.id, user_id: user.id)

      record.stance = stance
      record.save!

      record
    end

    def self.counts_for(topic)
      DiscourseDebates::Stance.where(topic_id: topic.id).group(:stance).count
    end

    def self.user_stance(topic:, user:)
      DiscourseDebates::Stance.find_by(topic_id: topic.id, user_id: user.id)&.stance
    end
  end
end
