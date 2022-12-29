module RecurringPromptScheduleStrategies
  class MonthlyPrompt
    attr_reader :recurring_prompt

    def initialize(recurring_prompt)
      @recurring_prompt = recurring_prompt
    end

    def should_create_prompt?
      return false unless current_time_is_scheduled_date?

      return false if already_made_prompt?

      return true
    end

    private

    def current_time_is_scheduled_date?
      current_time.day == @recurring_prompt.schedule_interval
    end

    def already_made_prompt?
      same_year? && same_month?
    end

    def most_recent_prompt
      @most_recent_prompt ||= @recurring_prompt.prompts.last
    end

    def current_time
      @current_time ||= Time.now
    end

    def same_year?
      most_recent_prompt&.created_at&.year == current_time.year
    end

    def same_month?
      most_recent_prompt&.created_at&.month == current_time.month
    end
  end
end