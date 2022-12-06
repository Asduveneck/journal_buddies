module RecurringPromptScheduleTypes
  class DailyPrompt
    def should_create_prompt?
      return false if already_made_prompt?

      return true
    end

    private

    def already_made_prompt?
      # figure out what to do here...
      same_date? && same_month? && same_year?
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

    def same_month?
      most_recent_prompt&.scheduled_date.year == Time.now.month
    end

    def same_day?
      most_recent_prompt&.scheduled_date.year == Time.now.day
    end

    def same_year?
      most_recent_prompt&.scheduled_date.year == Time.now.year
    end
  end
end