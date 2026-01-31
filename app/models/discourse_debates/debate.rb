# frozen_string_literal: true
#
module DiscourseDebates
  class Debate < ::ActiveRecord::Base
    self.table_name = "discourse_debates"

    belongs_to :topic

    enum :status, { suggestion: 0, open: 1, closed: 2 }
  end
end
