class ChangePrompts < ActiveRecord::Migration[7.0]
  def change
    change_table :prompts do |t|
      t.remove :parent_prompt
      t.references :recurring_prompt, foreign_key: true
    end
  end
end
