# frozen_string_literal: true

# name: debates
# about: Debate + Suggestion Box
# version: 0.1
# authors: You
# url: TODO
# required_version: 2.7.0

enabled_site_setting :debates_enabled

module ::DebatesModule
  PLUGIN_NAME = "debates"
end

require_relative "lib/debates_module/engine"

after_initialize do
  # Code which should run after Rails has finished booting
end
