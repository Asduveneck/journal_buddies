class CreateRecurringPrompts < ActiveRecord::Migration[7.0]
  def change
    create_table :recurring_prompts do |t|
      t.string :title
      t.boolean :is_active
      t.boolean :is_time_important
      t.datetime :start_date
      t.string :schedule_type, limit: 4
      t.integer :schedule_interval
      t.references :journal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
