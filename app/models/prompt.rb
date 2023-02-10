class Prompt < ApplicationRecord
  belongs_to :journal
  belongs_to :recurring_prompt, optional: true
  has_many :entries

  def sibling_prompts
    return [] unless recurring_prompt

    return recurring_prompt.prompts
  end

  # does a prompt need a scheduled date?


  def prompt_title
    return title || recurring_prompt.title || ""
  end
end
