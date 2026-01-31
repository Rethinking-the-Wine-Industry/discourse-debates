# name: discourse-debates
# about: Debate + Suggestion Box
# version: 0.1
# authors: Rethinking Wine
# url: https://github.com/Rethinking-the-Wine-Industry/discourse-debates

register_asset "config/settings.yml"
register_asset "stylesheets/common/discourse-debates.scss"
register_asset "stylesheets/common/debate-stance.scss"

enabled_site_setting :discourse_debates_enabled
require_relative File.expand_path("../app/models/discourse_debates/stance.rb", __FILE__)

after_initialize do
  module ::DiscourseDebates
    class Engine < ::Rails::Engine
      engine_name "discourse_debates"
      isolate_namespace DiscourseDebates
    end
  end

  if defined?(DiscourseDebates::Stance)
    Rails.logger.info "[discourse-debates] Stance model loaded"
  else
    Rails.logger.error "[disourse-debates] Stance model NOT loaded"
  end

  add_to_serializer(:topic_view, :debate_stance) do
    # puts "DEBUG: Serializing stance for topic #{object.topic.id}"
    ::DiscourseDebates::Stance.find_by(topic_id: object.topic.id, user_id: scope.user&.id)&.stance
  end

  register_topic_custom_field_type("debate_stance", :string)
  if respond_to?(:register_editable_topic_custom_field)
    register_editable_topic_custom_field(:debate_stance)
  end

  # 2. Adiciona o campo ao JSON que o front-end recebe
  # add_to_serializer(:topic_view, :debate_stance) { object.topic.custom_fields["debate_stance"] }

  # 3. Se precisar na lista de tópicos (Topic List), adicione aqui também:
  # add_to_serializer(:topic_list_item, :debate_stance) { object.custom_fields["debate_stance"] }

  require_relative "app/serializers/discourse_debates/topic_view_serializer_extension"
  ::TopicViewSerializer.prepend(DiscourseDebates::TopicViewSerializerExtension)

  require_relative "app/services/discourse_debates/stance_manager"
  require_relative "app/controllers/discourse_debates/stances_controller"

  Discourse::Application.routes.append { mount ::DiscourseDebates::Engine, at: "/debates" }
  DiscourseDebates::Engine.routes.draw do
    post "/:topic_id/stance" => "stances#set", :defaults => { format: :json }
  end
end
