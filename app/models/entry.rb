class Entry < ApplicationRecord
  belongs_to :prompt
  belongs_to :user

  validates :text, :user_id, :prompt_id, presence: true

  def prompt_text
    prompt.prompt
  end

  def sibling_entries
    prompt.entries
  end
end
