class AddVoteToDiscourseDebatesSuggestionVotes < ActiveRecord::Migration[7.0]
  def change
    add_column :discourse_debates_suggestion_votes, :vote, :integer, null: false
  end
end
