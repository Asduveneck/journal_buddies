module RecurringPromptScheduleStrategies
  class WeeklyPrompt
    attr_reader :recurring_prompt

    def initialize(recurring_prompt)
      @recurring_prompt = recurring_prompt
    end

    # mixin for some shared functionality?
    def create_prompt?
      return false unless current_time_is_scheduled_date?

      return false if already_made_prompt?

      return true
    end

    private

    def current_time_is_scheduled_date?
      # note: 0..6
      current_time.wday == @recurring_prompt.schedule_interval
    end

    def already_made_prompt?
      return true if most_recent_prompt.nil?

      same_year? && same_day? && same_month?
    end

    def most_recent_prompt
      @most_recent_prompt ||= @recurring_prompt.prompts.last
    end

    def current_time
      @current_time ||= Time.now
    end

    def same_month?
      most_recent_prompt&.created_at.month == current_time.month
    end

    def same_day?
      most_recent_prompt&.created_at.day == current_time.day
    end

    def same_year?
      most_recent_prompt&.created_at.year == current_time.year
    end
  end
end
