# frozen_string_literal: true

DebatesModule::Engine.routes.draw do
  get "/examples" => "examples#index"
  # define routes here
end

Discourse::Application.routes.draw { mount ::DebatesModule::Engine, at: "my-plugin" }
