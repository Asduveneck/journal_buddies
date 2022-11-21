require 'rails_helper'

RSpec.describe ::Entry, type: :model do
  describe 'initialization' do
    let(:params) { nil }

    let(:entry_text) { 'journal entry response' }

    it 'is invalid without a user' do
      entry = Entry.new(text: entry_text, user_id: nil, prompt_id: 1)
      expect(entry).to_not be_valid
    end

    it 'is invalid without a prompt' do
      entry = Entry.new(text: entry_text, user_id: 1, prompt_id: nil)
      expect(entry).to_not be_valid
    end

    it 'is invalid without a text' do
      entry = Entry.new(text: nil, user_id: 1, prompt_id: 1)
      expect(entry).to_not be_valid
    end

  it 'is valid with a user, prompt and text' do
    entry = Entry.new(text: entry_text, user_id: 1, prompt_id: 1)
    expect(entry).to be_valid
  end

  end

  describe '#prompt_text' do
    # Warning: Factorybot / Factorygirl not installed yet...
    let(:prompt) { build_stubbed(:prompt, prompt: "What did you eat today?") }
    let(:user) { build_stubbed(:user, first_name: "Sam") }
    let(:entry) { build_stubbed(:entry, prompt_id: prompt.id, user_id: user.id) }

    it 'can access the prompt text' do
      expect(entry.prompt).to eq prompt.prompt
    end
  end

  describe '#sibling_entries' do
    let(:prompt) { stubbed(:prompt, prompt: 'What did you eat today?') }
    let(:user_one) { build_stubbed(:user, first_name: 'Sam') }
    let(:user_two) { build_stubbed(:user, first_name: 'Fran') }
    let(:user_three) { build_stubbed(:user, first_name: 'Bill') }
    let(:entry_one) { build_stubbed(:entry, text: 'entry one', prompt_id: prompt.id, user_id: user_one.id) }
    let(:entry_two) { build_stubbed(:entry, text: 'entry two', prompt_id: prompt.id, user_id: user_two.id) }
    let(:entry_three) { build_stubbed(:entry, text: 'entry three', prompt_id: prompt.id, user_id: user_three.id) }

    it 'returns all sibling entries for the same parent prompt' do
      expected_entries = [entry_one, entry_two, entry_three]
      expect(entry_one.sibling_entries).to include(*expected_entries)
      expect(entry_two.sibling_entries).to include(*expected_entries)
      expect(entry_three.sibling_entries).to include(*expected_entries)
    end
  end
end
