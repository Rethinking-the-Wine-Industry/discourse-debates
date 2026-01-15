# frozen_string_literal: true

# name: discourse-debates
# about: Structured debates with suggestion box, voting, and stance selection
# version: 0.1.0
# authors: Your Name
# url: https://github.com/your-org/discourse-debates

enabled_site_setting :debate_enabled

register_asset "stylesheets/debates.scss"

after_initialize do
  module ::DiscourseDebates
    PLUGIN_NAME = "discourse-debates"
  end

  # == Models ==
  require_relative "app/models/debate_stance"

  # == Controllers ==
  require_relative "app/controllers/discourse_debates/stances_controller"

  # == Routes ==
  Discourse::Application.routes.append do
    mount ::DiscourseDebates::Engine, at: "/debate"
  end

  # == Topic Custom Fields ==
  Topic.register_custom_field_type("debate_counts", :json)
  Topic.register_custom_field_type("is_debate", :boolean)

  # == Preload fields for serializers ==
  add_to_serializer(:topic_view, :debate_counts) do
    object.topic.custom_fields["debate_counts"]
  end

  add_to_serializer(:topic_view, :is_debate) do
    object.topic.custom_fields["is_debate"]
  end

  add_to_serializer(:topic_view, :debate_stance) do
    object.topic_view&.user_data&.custom_fields&.dig("debate_stance")
  end

end
