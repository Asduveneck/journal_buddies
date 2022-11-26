require 'rails_helper'

RSpec.describe ::Entry, type: :model do
  describe 'initialization' do
    let(:params) { nil }

    let(:entry_text) { 'journal entry response' }
    let(:user) { build_stubbed(:user) }
    let(:prompt) { build_stubbed(:prompt) }

    it 'is invalid without a user' do
      entry = Entry.new(text_content: entry_text, user_id: nil, prompt_id: prompt.id)
      expect(entry).to_not be_valid
    end

    it 'is invalid without a prompt' do
      entry = Entry.new(text_content: entry_text, user_id: user.id, prompt_id: nil)
      expect(entry).to_not be_valid
    end

    it 'is invalid without a text' do
      entry = Entry.new(text_content: nil, user_id: user.id, prompt_id: prompt.id)
      expect(entry).to_not be_valid
    end

  it 'is valid with a user, prompt and text' do
    entry = Entry.new(text_content: entry_text, user_id: user.id, prompt_id: prompt.id)
    expect(entry).to be_valid
  end

  end

  describe '#prompt_text' do
    # Warning: Factorybot / Factorygirl not installed yet...
    let(:prompt) { build_stubbed(:prompt, title: "What did you eat today?") }
    let(:user) { build_stubbed(:user, first_name: "Sam") }
    let(:entry) { build_stubbed(:entry, prompt_id: prompt.id, user_id: user.id) }

    it 'can access the prompt text' do
      expect(entry.prompt).to eq prompt.title
    end
  end

  describe '#sibling_entries' do
    # WAIT: may make sense to add a master or schedulable prompt, and since that is more important,
    # don't nother with this spec until I add that table and fix the prompts table to not reference itself
    # TODO: refactor via following, which will hopefully fix all the association specs...
    # see https://github.com/thoughtbot/factory_bot/blob/main/GETTING_STARTED.md#has_many-associations
    let(:prompt) { build_stubbed(:prompt, title: 'What did you eat today?') }
    let(:user_one) { build_stubbed(:user, first_name: 'Sam') }
    let(:user_two) { build_stubbed(:user, first_name: 'Fran') }
    let(:user_three) { build_stubbed(:user, first_name: 'Bill') }
    let(:entry_one) { build_stubbed(:entry, text_content: 'entry one', prompt_id: prompt.id, user_id: user_one.id) }
    let(:entry_two) { build_stubbed(:entry, text_content: 'entry two', prompt_id: prompt.id, user_id: user_two.id) }
    let(:entry_three) { build_stubbed(:entry, text_content: 'entry three', prompt_id: prompt.id, user_id: user_three.id) }

    it 'returns all sibling entries for the same parent prompt' do
      expected_entries = [entry_one, entry_two, entry_three]
      expect(entry_one.sibling_entries).to include(*expected_entries)
      expect(entry_two.sibling_entries).to include(*expected_entries)
      expect(entry_three.sibling_entries).to include(*expected_entries)
    end
  end
end
