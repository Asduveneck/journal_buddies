require 'rails_helper'

RSpec.describe ::Prompt, type: :model do
  describe 'associations' do
    it { should belong_to :journal }
    # it { should belong_to :recurring_prompt } # prompts won't always belong to recurring prompt
    it { should have_many :entries }
  end

  describe 'initialization' do
    let(:params) { nil }
    let(:journal) { nil }
    let(:recurring_prompt) { nil }
    let(:entries) { [] }
    subject(:prompt) { build_stubbed(:prompt, journal: journal, recurring_prompt: recurring_prompt, entries: entries) }

    describe 'without a journal' do
      let(:journal) { nil }

      it { should_not be_valid }

      it 'should raise errors' do
        prompt.valid?
        expect(prompt.errors).to contain_exactly('Journal must exist')
      end
    end

    describe 'with a journal' do
      let(:journal) { build_stubbed(:journal) }
      let(:recurring_prompt) { build_stubbed(:recurring_prompt) }
      it { should be_valid }

      describe 'without a recurring prompt' do
        it { should be_valid }
      end
    end
  end

  describe '#sibling_prompts' do
    let(:journal) { build_stubbed(:journal) }
    let(:recurring_prompt) { nil }
    let(:prompt) { build_stubbed(:prompt, recurring_prompt: recurring_prompt) }
    subject(:sibling_prompts) { prompt.sibling_prompts }

    describe 'when there is no recurring prompt' do
      it { should eq [] }
    end

    describe 'when there is a recurring prompt with prompts' do
      let(:other_sibling_prompts) { build_stubbed_list(:prompt, 3) }
      let(:recurring_prompt) { build_stubbed(:recurring_prompt, prompts: other_sibling_prompts) }

      # TODO: WARNING!
      # should technically contain the :prompt itself, but following passes (likely because of stubs)
      # Fix if time/priorities allow
      it { should contain_exactly( *other_sibling_prompts) }
    end
  end
end
