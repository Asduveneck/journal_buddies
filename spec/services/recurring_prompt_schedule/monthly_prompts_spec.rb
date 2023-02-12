require 'rails_helper'

RSpec.describe ::RecurringPromptScheduleStrategies::MonthlyPrompt, type: :service do
  frozen_time = Time.local(2008, 9, 1, 10, 13)
  let(:prompts) { [] }
  let(:recurring_prompt) do
    build_stubbed(:recurring_prompt, :monthly, schedule_interval: frozen_time.day, prompts: prompts )
  end
  subject(:create_prompt?) { recurring_prompt&.create_prompt? }

  before(:context) { Timecop.freeze(frozen_time) }
  after(:context) { Timecop.return }

  describe 'when the current day is not the scheduled day' do
    before(:example) { Timecop.travel(frozen_time.next_day) }
    after(:example) { Timecop.travel(frozen_time) }
    it { should be false }
  end

  # what about end of month? 31st? and for shorter months too, like February?
  describe 'when there is a prompt on the correct day' do
    let(:prompts) { [build_stubbed(:prompt, created_at: frozen_time)] }

    describe 'and the prompt is from this month' do
      it { should be false }
    end

    describe 'and the prompt is one month ago' do
      before(:example) { Timecop.travel(frozen_time.next_month) }

      it { should be true }
    end

    describe 'and the prompt is two months ago' do
      before(:example) do
        next_month = frozen_time.next_month
        two_months_from_now = next_month.next_month
        Timecop.travel(two_months_from_now)
      end

      it { should be true }
    end
  end
end
