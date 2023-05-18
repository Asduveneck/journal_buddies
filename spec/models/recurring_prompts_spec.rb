require 'rails_helper'

RSpec.describe ::RecurringPrompt, type: :model do
  describe 'associations' do
    it { should belong_to :journal }
    it { should have_many :prompts }
  end
end
