class CreateJoinTableUsersJournals < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :journals do |t|
      # t.index [:user_id, :journal_id]
      # t.index [:journal_id, :user_id]
      t.column :user_roles, "ENUM('admin', 'prompt_writer', 'participant', 'viewer')"
    end
  end
end
