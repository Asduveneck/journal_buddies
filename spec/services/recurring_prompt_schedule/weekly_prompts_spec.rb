require 'rails_helper'

RSpec.describe ::RecurringPromptScheduleStrategies::WeeklyPrompt, type: :service do
  frozen_time = Time.local(2008, 9, 1, 10, 13)
  let(:prompts) { [] }
  let(:recurring_prompt) do
    build_stubbed(:recurring_prompt, :weekly, prompts: prompts, schedule_interval: frozen_time.wday)
  end
  subject(:create_prompt?) { recurring_prompt&.create_prompt? }

  before(:context) { Timecop.freeze(frozen_time) }
  after(:context) { Timecop.return }

  describe 'when the current time is not the correct weekday' do
    before(:example) { Timecop.travel(frozen_time.next_day) }
    it { should be false }
  end

  describe 'when it is the correct date' do
    let(:prompts) { [build_stubbed(:prompt, created_at: frozen_time)] }

    describe 'and the prompt is from this date' do
      it { should be false }
    end

    describe 'and the prompt is one week ago' do
      before(:example) { Timecop.travel(frozen_time.next_week) }

      it { should be true }
    end

    describe 'and the prompt is two weeks ago' do
      before(:example) do
        next_week = frozen_time.next_week
        two_weeks_from_now = next_week.next_week
        Timecop.travel(two_weeks_from_now)
      end

      it { should be true }
    end
  end
end
