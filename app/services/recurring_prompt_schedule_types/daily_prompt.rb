module RecurringPromptScheduleTypes
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
      same_date? && same_month? && same_year?
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
      most_recent_prompt&.created_at&.month == Time.now.month
    end

    # date or day?
    def same_date?
      most_recent_prompt&.created_at&.day == Time.now.day
    end

    def same_year?
      most_recent_prompt&.created_at&.year == Time.now.year
    end
  end
end