class Journal < ApplicationRecord
  has_many :prompts
  has_many :recurring_prompts
  has_many :journals_users
  has_many :users, through: :journals_users

  def pending_recurring_prompts
    @pending_recurring_prompts ||= recurring_prompts.filter { |recurring_prompt| recurring_prompt.create_prompt? }
  end
end
