class Journal < ApplicationRecord
  has_many :prompts
  has_many :journals_users
  has_many :users, through: :journals_users

  # Recurring prompts and prompts should be handled

end
