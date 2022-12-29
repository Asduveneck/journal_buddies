require 'rails_helper'

RSpec.describe ::RecurringPromptScheduleStrategies::AnnualPrompt, type: :service do
  frozen_time = Time.local(2008, 9, 1, 10, 13)
  let(:recurring_prompt) { build_stubbed(:recurring_prompt, :annual )}
  subject(:should_create_prompt?) { recurring_prompt&.should_create_prompt? }

  before(:context) { Timecop.freeze(frozen_time) }
  after(:context) { Timecop.return }

  describe 'when the current time is not the same day and month as the start date' do
    let(:recurring_prompt) { build_stubbed(:recurring_prompt, :annual, start_date: frozen_time)}
    before(:example) { Timecop.travel(frozen_time.next_day) }
    it { should be false }
  end

  describe 'when it is the correct date' do
    let(:prompt) { build_stubbed(:prompt) }
    let(:recurring_prompt) do
      build_stubbed(:recurring_prompt, :annual, start_date: frozen_time, prompts: [prompt])
    end

    describe 'and the prompt is from this year' do
      it { should be false }
    end

    describe 'and the prompt is one year ago' do
      before(:example) { Timecop.travel(frozen_time.next_year) }

      it { should be true }
    end
  end
end
