class Journal < ApplicationRecord
  has_many :prompts
  has_many :users, through: journal_user

end
