class RecurringPrompt < ApplicationRecord
  belongs_to :journal

  has_many :prompts

  # handle schedule the schedule
  def create_prompt
  end

  def should_create_prompt
  end

  private

  def processed_recurring_prompt
    @processed_recurring_prompt ||= begin
      return RecurringPromptScheduleTypes::AnnualPrompt.new(self) if annual_schedule?
      return RecurringPromptScheduleTypes::DailyPrompt.new(self) if adaily_schedule?
      return RecurringPromptScheduleTypes::MonthlyPrompt.new(self) if amonthly_schedule?
      return RecurringPromptScheduleTypes::WeeklyPrompt.new(self) if weekly_schedule?
    end
  end

  def annual_schedule?
    schedule_type == "a"
  end

  def daily_schedule?
    schedule_type == "d"
  end

  def monthly_schedule?
    schedule_type == "m"
  end

  def weekly_schedule?
    schedule_type == "w"
  end
end
