class Entry < ApplicationRecord
  belongs_to :prompt
  belongs_to :user

  validates :text_content, :user_id, :prompt_id, presence: true

  def prompt_text
    prompt.title
  end

  def sibling_entries
    prompt.entries
  end
end
