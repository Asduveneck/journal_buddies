module RecurringPromptScheduleTypes
  class WeeklyPrompt
    attr_reader :recurring_prompt

    def initialize(recurring_prompt)
      @recurring_prompt = recurring_prompt
    end

    # where is constructor?
    # mixin for some shared functionality?
    def should_create_prompt?
      return false unless current_time_is_scheduled_date?

      return false if already_made_prompt?

      return true
    end

    private

    def current_time_is_scheduled_date?
      # note: 0..6
      current_time.wday == @recurring_prompt..schedule_interval
    end

    def already_made_prompt?
      same_year? && same_day? && same_month?
    end

    def most_recent_prompt
      @most_recent_prompt ||= @recurring_prompt.prompts.last
    end

    def current_time
      @current_time ||= Time.now
    end

    def same_month?
      most_recent_prompt&.scheduled_date.year == current_time.month
    end

    def same_day?
      most_recent_prompt&.scheduled_date.year == current_time.day
    end

    def same_year?
      most_recent_prompt&.scheduled_date.year == current_time.year
    end
  end
end