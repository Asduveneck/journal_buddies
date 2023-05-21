class CreateJoinTableUsersJournals < ActiveRecord::Migration[7.0]
  def change
    create_enum :user_role, ['admin', 'prompt_writer', 'participant', 'viewer']
    create_join_table :users, :journals do |t|
      # t.index [:user_id, :journal_id]
      # t.index [:journal_id, :user_id]
      t.enum :user_role,  enum_type: "user_role", default: "participant", null: false
    end
  end
end
