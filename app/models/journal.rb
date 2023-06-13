class Journal < ApplicationRecord
  has_many :prompts
  has_many :recurring_prompts
  has_many :journals_users
  accepts_nested_attributes_for :journals_users, reject_if: proc { |attributes| attributes['user_id'].blank? }
  has_many :users, through: :journals_users

  validates :name, presence: true

  def pending_recurring_prompts
    @pending_recurring_prompts ||= recurring_prompts.filter { |recurring_prompt| recurring_prompt.create_prompt? }
  end
end
