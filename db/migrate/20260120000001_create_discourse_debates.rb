class CreateDiscourseDebates < ActiveRecord::Migration[7.0]
  def change
    create_table :discourse_debates do |t|
      t.integer :topic_id, null: false
      t.integer :status, null: false, default: 0
      t.timestamps
    end

    add_index :discourse_debates, :topic_id, unique: true
  end
end
