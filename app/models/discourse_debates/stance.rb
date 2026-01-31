# frozen_string_literal: true
#
module DiscourseDebates
  class Stance < ActiveRecord::Base
    self.table_name = "discourse_debates_stances"

    belongs_to :user
    belongs_to :topic

    enum :stance, { "for" => 0, "neutral" => 1, "against" => 2 }
  end
end
