# name: discourse-debates
# about: Debate + Suggestion Box
# version: 0.1
# authors: Rethinking Wine
# url: https://github.com/Rethinking-the-Wine-Industry/discourse-debates

register_asset "config/settings.yml"

enabled_site_setting :discourse_debates_enabled

after_initialize do
  module ::DiscourseDebates
    class Engine < ::Rails::Engine
      engine_name "discourse_debates"
      isolate_namespace DiscourseDebates
    end
  end
end


