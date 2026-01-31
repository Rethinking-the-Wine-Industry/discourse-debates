# frozen_string_literal: true

module DiscourseDebates
  class SuggestionPromoter
    Result = Struct.new(:success?, :message)

    def self.call(topic, force: false)
      new(topic, force: force).call
    end

    def initialize(topic, force:)
      @topic = topic
      @force = force
    end

    def call
      return fail!("Not a suggestion topic") unless suggestion_topic?
      return fail!("Not enough time passed") unless @force || eligible_by_time?
      return fail!("Suggestion not approved") unless approved?

      promote!
      Result.new(
        true,
        (
          if @force
            "Suggestion promoted to Debate (manual override)"
          else
            "Suggestion promoted to Debate"
          end
        ),
      )
    rescue => e
      Rails.logger.error("[discourse-debates] #{e}")
      Result.new(false, e.message)
    end

    private

    def suggestion_topic?
      @topic.category_id == SiteSetting.discourse_debates_suggestion_category_id
    end

    def eligible_by_time?
      @topic.created_at <= SiteSetting.discourse_debates_suggestion_days.days.ago
    end

    def approved?
      votes = DiscourseDebates::SuggestionVote.where(topic_id: @topic.id).group(:vote).count

      (votes["yes"] || 0) > (votes["no"] || 0)
    end

    def promote!
      Topic.transaction do
        @topic.update!(category_id: SiteSetting.discourse_debates_debate_category_id)

        DiscourseDebates::Debate.find_or_create_by!(topic_id: @topic.id)

        @topic.custom_fields["debate_promoted_at"] = Time.now
        @topic.save_custom_fields
      end
    end

    def fail!(msg)
      Result.new(false, msg)
    end
  end
end
