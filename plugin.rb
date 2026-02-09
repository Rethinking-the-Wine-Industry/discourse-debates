# frozen_string_literal: true
# name: discourse-debates
# about: Debate + Suggestion Box
# version: 0.1
# authors: Rethinking Wine
# url: https://github.com/Rethinking-the-Wine-Industry/discourse-debates

register_asset "config/settings.yml"
register_asset "stylesheets/common/discourse-debates.scss"
register_svg_icon "wine-glass"

enabled_site_setting :discourse_debates_enabled

require_relative "lib/discourse_debates/topic_extension"
require_relative File.expand_path("../app/models/discourse_debates/stance.rb", __FILE__)
require_relative File.expand_path("../app/models/discourse_debates/suggestion_vote.rb", __FILE__)

after_initialize do
  reloadable_patch { Topic.prepend(DiscourseDebates::TopicExtension) }

  # Adding fields to the serializaer, which will expose them to the frontend
  #
  register_topic_custom_field_type("current_user_vote", :string)
  register_topic_custom_field_type("counts", :object)
  register_topic_custom_field_type("current_user_stance", :string)
  register_topic_custom_field_type("stance_count", :string)

  if respond_to?(:register_editable_topic_custom_field)
    register_editable_topic_custom_field(:current_user_stance)
    register_editable_topic_custom_field(:stance_count)
  end

  add_to_serializer(:topic_view, :is_debate) do
    return nil unless scope.user
    object.topic.debate_topic?
  end

  add_to_serializer(:topic_view, :is_suggestion) do
    return nil unless scope.user
    object.topic.suggestion_topic?
  end

  add_to_serializer(
    :topic_view,
    :current_user_stance,
    include_condition: -> { object.topic.debate_topic? },
  ) do
    return nil unless scope.user
    ::DiscourseDebates::Stance.find_by(topic_id: object.topic.id, user_id: scope.user.id)&.stance
  end

  add_to_serializer(
    :topic_view,
    :current_user_vote,
    include_condition: -> { object.topic.suggestion_topic? },
  ) do
    return nil unless scope.user
    ::DiscourseDebates::SuggestionVote.find_by(topic_id: topic.id, user_id: scope.user.id)&.vote
  end

  add_to_serializer(
    :topic_view,
    :suggestion_vote_count,
    include_condition: -> { object.topic.suggestion_topic? },
  ) do
    return nil unless scope.user

    votes = ::DiscourseDebates::SuggestionVote.where(topic_id: topic.id)
    { yes: votes.yes.count, no: votes.no.count }
  end

  add_to_serializer(
    :topic_view,
    :stance_count,
    include_condition: -> { object.topic.debate_topic? },
  ) do
    return nil unless scope.user
    stances = ::DiscourseDebates::Stance.where(topic_id: object.topic.id)
    { for: stances.for.count, neutral: stances.neutral.count, against: stances.against.count }
  end

  add_to_serializer(:post, :current_user_stance) { object.custom_fields["current_user_stance"] }

  on(:post_created) do |post|
    return nil unless post.user

    stance =
      ::DiscourseDebates::Stance.find_by(topic_id: post.topic_id, user_id: post.user.id)&.stance

    post.custom_fields["current_user_stance"] = stance
    post.save_custom_fields(true)
  end

  require_relative "app/services/discourse_debates/stance_manager"
  require_relative "app/controllers/discourse_debates/stances_controller"
  require_relative "app/controllers/discourse_debates/suggestions_controller"

  module ::DiscourseDebates
    class Engine < ::Rails::Engine
      engine_name "discourse_debates"
      isolate_namespace DiscourseDebates
    end
  end

  ::DiscourseDebates::Engine.routes.draw do
    post "/stances/:topic_id" => "stances#set", :defaults => { format: :json }
    post "/suggestions/:topic_id" => "suggestions#vote", :defaults => { format: :json }
  end

  Discourse::Application.routes.append { mount ::DiscourseDebates::Engine, at: "/debates" }
end
