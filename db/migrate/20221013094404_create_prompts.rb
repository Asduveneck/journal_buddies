class CreatePrompts < ActiveRecord::Migration[7.0]
  def change
    create_table :prompts do |t|
      t.string :prompt
      t.boolean :editable
      t.date :scheduled_date
      t.references :journal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
