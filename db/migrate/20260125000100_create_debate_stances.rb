# frozen_string_literal: true
# plugins/discourse-debates/db/migrate/20260125000100_create_debate_stances.rb
class CreateDebateStances < ActiveRecord::Migration[7.0]
  def change
    create_table :discourse_debates_stances do |t|
      t.integer :topic_id, null: false
      t.integer :user_id, null: false
      t.integer :stance, null: false
      t.timestamps
    end

    add_index :discourse_debates_stances,
              %i[topic_id user_id],
              unique: true,
              name: "idx_debate_stances_topic_user"
  end
end
