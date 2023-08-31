require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many :journals_users }
    it { should have_many(:journals).through(:journals_users) }
  end
end
