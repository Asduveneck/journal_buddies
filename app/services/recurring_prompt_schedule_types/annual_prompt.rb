module RecurringPromptScheduleTypes
  class AnnualPrompt

    # where is constructor?

    def should_create_prompt?
      return false unless current_time_is_scheduled_date?

      return false if most_recent_prompt_date_same_year?

      return true
    end

    private

    def current_time_is_scheduled_date?
      current_time.day == scheduled_date.day && current_time.month == scheduled_date.month
    end

    def most_recent_prompt_date_same_year?
      most_recent_prompt&.scheduled_date.year == current_time.year
    end

    def most_recent_prompt
      @most_recent_prompt ||= prompts.last
    end

    def current_time
      @current_time ||= Time.now
    end

    def current_year?
      most_recent_prompt&.scheduled_date.year == Time.now.year
    end
  end
end