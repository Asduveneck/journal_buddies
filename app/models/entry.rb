class Entry < ApplicationRecord
  belongs_to :prompt
  belongs_to :user
  
  has_one :journal, through: :prompt
  has_many :journals_users, through: :journal
  validates :text_content, :user_id, :prompt_id, presence: true

  def prompt_text
    prompt.title
  end

  def sibling_entries
    prompt.entries
  end
end
