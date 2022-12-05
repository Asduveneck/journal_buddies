class RecurringPrompt < ApplicationRecord
  belongs_to :journal

  has_many :prompts

  # handle schedule the schedule
  def create_prompt
  end

  def should_create_prompt
  end

  private

  def daily_schedule?
    schedule_type == "d"
  end

  def weekly_schedule?
    schedule_type == "w"
  end

  def monthly_schedule?
    schedule_type == "m"
  end

  def annual_schedule?
    schedule_type == "a"
  end


end
