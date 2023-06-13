require 'rails_helper'

# TODO: Use gem shoulda: https://github.com/thoughtbot/shoulda-matchers
# to clean up all these associations
RSpec.describe ::Entry, type: :model do
  describe 'associations' do
    it { should belong_to :prompt }
    it { should belong_to :user }
    it { should have_one :journal }
    it { should have_many :journals_users }
  end

  describe 'validations' do
    it { should validate_presence_of :text_content }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :prompt_id }
  end

  describe 'initialization' do
    let(:params) { nil }

    let(:user) { build_stubbed(:user) }
    let(:prompt) { build_stubbed(:prompt) }
    let(:entry_text) { 'journal entry response' }
    let(:expected_errors) { [] }
    subject(:entry) { build_stubbed(:entry, text_content: entry_text, prompt: prompt, user: user) }

    RSpec.shared_examples 'an invalid entry' do
      it { should_not be_valid }

      it 'should raise errors' do
        entry.valid?
        expect(entry.errors).to contain_exactly(*expected_errors)
      end
    end

    describe 'without a user' do
      subject(:entry) { build_stubbed(:entry, text_content: entry_text, prompt: prompt) }
      let(:expected_errors) { ['User must exist', 'User can\'t be blank'] }

      it_behaves_like 'an invalid entry'
    end

    describe 'without a prompt' do
      subject(:entry) { build_stubbed(:entry, text_content: entry_text, user: user) }
      let(:expected_errors) { ['Prompt must exist','Prompt can\'t be blank'] }

      it_behaves_like 'an invalid entry'
    end

    describe 'without a text' do
      subject(:entry) { build_stubbed(:entry, prompt: prompt, user: user ) }
      let(:expected_errors) { ['Text content can\'t be blank'] }

      it_behaves_like 'an invalid entry'
    end

    describe 'with a user, prompt, and text' do
      subject(:entry) { build_stubbed(:entry, text_content: entry_text, prompt: prompt, user: user) }

      it { should be_valid }
    end
  end

  describe '#prompt_text' do
    let(:prompt) { build_stubbed(:prompt, title: "What did you eat today?") }
    let(:user) { build_stubbed(:user, first_name: "Sam") }
    let(:entry) { build_stubbed(:entry, prompt: prompt, user: user) }

    it 'can access the prompt text' do
      expect(entry.prompt_text).to eq prompt.title
    end
  end

  describe '#sibling_entries attempt' do
    let(:prompt) { build_stubbed(:prompt_with_sibling_entries, sibling_entries_count: 3)}
    let(:prompt_entries) { prompt.entries }

    it 'each entry from the same prompt can find sibling entries' do
      prompt_entries.each do |entry|
        expect(entry.sibling_entries).to contain_exactly(*prompt_entries)
      end
    end
  end
end
