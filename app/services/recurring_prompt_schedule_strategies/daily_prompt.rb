module RecurringPromptScheduleStrategies
  class DailyPrompt
    attr_reader :recurring_prompt

    def initialize(recurring_prompt)
      @recurring_prompt = recurring_prompt
    end

    def should_create_prompt?
      return false if already_made_prompt?

      return true
    end

    private

    def already_made_prompt?
      same_day? && same_month? && same_year?
    end

    def most_recent_prompt_date_same_year?
      most_recent_prompt&.scheduled_date.year == current_time.year
    end

    def most_recent_prompt
      @most_recent_prompt ||= @recurring_prompt.prompts.last
    end

    def current_time
      @current_time ||= Time.now
    end

    def same_month?
      most_recent_prompt&.created_at&.month == current_time.month
    end

    def same_day?
      most_recent_prompt&.created_at&.day == current_time.day
    end

    def same_year?
      most_recent_prompt&.created_at&.year == current_time.year
    end
  end
end