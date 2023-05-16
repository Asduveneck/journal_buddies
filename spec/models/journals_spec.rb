require 'rails_helper'

RSpec.describe ::Journal, type: :model do
  let(:name) { '' }
  let(:description) { '' }
  let(:recurring_prompts) { [] }
  subject(:journal) { build_stubbed(:journal, name: name, description: description, recurring_prompts: recurring_prompts) }

  describe 'initialization' do
    describe 'without a description' do
      let(:name) { 'My journal' }
      it { should be_valid }
    end

    describe 'without a name' do
      let(:description) { 'My thoughts' }
      it { should_not be_valid }
    end
  end

  frozen_time = Time.local(2008, 9, 1, 10, 13)
  before(:context) { Timecop.freeze(frozen_time) }
  after(:context) { Timecop.return }

  describe '#pending_recurring_prompts' do
    let(:non_pending_prompts) { build_stubbed_list(:recurring_prompt, 3, :monthly, schedule_interval: frozen_time.day + 1) }
    let(:pending_prompts) { build_stubbed_list(:recurring_prompt, 3, :monthly, schedule_interval: frozen_time.day) }
    let( :recurring_prompts ) { [*non_pending_prompts, *pending_prompts] }

    it 'should only return recurring prompts that should be created' do
      expect(journal.pending_recurring_prompts).to contain_exactly(*pending_prompts)
    end
  end
end
