class RecurringPrompt < ApplicationRecord
  belongs_to :journal
  has_many :prompts

  def create_prompt
    return nil unless create_prompt?

    Prompt.new(editable: true, recurring_prompts_id: id)
  end

  def create_prompt?
    processed_recurring_prompt.create_prompt?
  end

  private

  def processed_recurring_prompt
    @processed_recurring_prompt ||= process_schedule
  end

  # strategy pattern
  def process_schedule
    return RecurringPromptScheduleStrategies::AnnualPrompt.new(self) if annual_schedule?
    return RecurringPromptScheduleStrategies::DailyPrompt.new(self) if daily_schedule?
    return RecurringPromptScheduleStrategies::MonthlyPrompt.new(self) if monthly_schedule?
    return RecurringPromptScheduleStrategies::WeeklyPrompt.new(self) if weekly_schedule?
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
