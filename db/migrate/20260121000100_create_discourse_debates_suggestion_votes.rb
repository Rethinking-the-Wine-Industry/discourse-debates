# frozen_string_literal: true

class CreateDiscourseDebatesSuggestionVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :discourse_debates_suggestion_votes do |t|
      t.integer :topic_id, null: false
      t.integer :user_id, null: false
      t.timestamps
    end

    add_index :discourse_debates_suggestion_votes,
              [:topic_id, :user_id],
              unique: true,
              name: "idx_discourse_debates_suggestion_votes_unique"

    add_index :discourse_debates_suggestion_votes, :topic_id
    add_index :discourse_debates_suggestion_votes, :user_id
  end
end
