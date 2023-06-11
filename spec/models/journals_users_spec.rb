require 'rails_helper'

RSpec.describe ::JournalsUser, type: :model do
  let(:user) { nil }
  let(:journal) { nil }
  subject(:journals_user) { build_stubbed(:journals_user, :as_admin, user: user, journal: journal) }

  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :journal }
  end

  describe 'validations' do
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :journal_id }
    it { should validate_presence_of :user_role }
  end
end
