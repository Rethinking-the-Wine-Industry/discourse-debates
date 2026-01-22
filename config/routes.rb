# frozen_string_literal: true

DiscourseDebates::Engine.routes.draw do
  post "/suggestions/:topic_id/vote" => "suggestions#vote"
end
