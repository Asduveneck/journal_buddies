class RecurringPrompt < ApplicationRecord
  belongs_to :journal

  has_many :prompts

  # handle schedule the schedule
end
