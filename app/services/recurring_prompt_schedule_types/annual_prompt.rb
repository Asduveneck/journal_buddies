module RecurringPromptScheduleTypes
  class AnnualPrompt
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
      current_time.day == scheduled_date.day && current_time.month == scheduled_date.month
    end

    def already_made_prompt?
      most_recent_prompt&.scheduled_date.year == current_time.year
    end

    def most_recent_prompt
      @most_recent_prompt ||= recurring_prompt.prompts.last
    end

    def current_time
      @current_time ||= Time.now
    end

    def current_year?
      most_recent_prompt&.scheduled_date.year == Time.now.year
    end
  end
end