# frozen_string_literal: true
#
module DiscourseDebates
  class DebatesController < ::ApplicationController
    requires_plugin "discourse-debates"

    def index
      render json: { ok: true }
    end
  end
end
