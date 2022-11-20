require 'rails_helper'

RSpec.describe ::Entry, type: :model do
  describe 'properties' do
    let(:params) { nil }

    let(:entry_text) { 'journal entry response' }

    it 'is invalid without a prompt and user' do
      entry = Entry.new(text: entry_text, user_id: nil, prompt_id: 1)
      expect(entry).to_not be_valid

    end

    it 'belongs to a prompt and user'
    it 'contains text'
  end

  describe '#prompt_text' do
    it 'can access the prompt text' do end
  end

  describe '#sibling_entries' do
    it 'returns all sibling entries for the same parent prompt'
  end
end
