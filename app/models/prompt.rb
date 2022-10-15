class Prompt < ApplicationRecord
  belongs_to :journal
  belongs_to :parent_prompt, :class_name => "Prompt"
  has_many :prompts, :foreign_key => "parent_prompt_id"
  has_many :entries

  def sibling_prompts
    return [] unless parent_prompt

    return parent_prompt.prompts
  end
end
