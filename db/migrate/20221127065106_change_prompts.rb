class ChangePrompts < ActiveRecord::Migration[7.0]
  def change
    change_table :prompts do |t|
      t.remove :parent_prompt_id
      t.references :recurring_prompts, foreign_key: true
    end
  end
end
