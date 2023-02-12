require 'rails_helper'

RSpec.describe ::RecurringPromptScheduleStrategies::DailyPrompt, type: :service do
  frozen_time = Time.local(2008, 9, 1, 10, 13)
  let(:prompts) { [] }
  let(:recurring_prompt) { build_stubbed(:recurring_prompt, :daily, prompts: prompts )}
  subject(:create_prompt?) { recurring_prompt&.create_prompt? }

  before(:context) { Timecop.freeze(frozen_time) }
  after(:context) { Timecop.return }

  describe 'when there is no existing prompt' do
    it { should be true }
  end

  describe 'when there is a prompt' do
    let(:prompts) { [build_stubbed(:prompt, created_at: frozen_time)] }

    describe 'and the prompt is today' do
      it { should be false }
    end

    describe 'and the prompt is one day ago' do
      before(:example) { Timecop.travel(frozen_time.next_day) }
      it { should be true }
    end
  end
end
