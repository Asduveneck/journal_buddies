class JournalsUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :journals_users do |t|
    
      t.references :journal, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :user_roles, array: true, default: []
    end
  end
end
