class CreateJoinTableUsersJournals < ActiveRecord::Migration[7.0]
  def change
    create_enum :user_role, ['admin', 'prompt_writer', 'participant', 'viewer']
    create_join_table :users, :journals do |t|
      t.integer :id, primary_key: true
      t.index :id
      t.index :user_id
      t.index :journal_id
      t.index [:user_id, :journal_id], unique: true
      t.enum :user_role,  enum_type: "user_role", default: "participant", null: false
    end
  end
end
