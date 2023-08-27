require 'rails_helper'

RSpec.describe Api::CurrentUsersController, type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) {
    create(:user, first_name: 'John', last_name: 'Smith', password: 'password')
  }
  let(:user_id) { user.id }
  let(:path) { nil }
  let(:request) { proc { return nil } }

  RSpec.shared_examples 'an unauthorized endpoint' do
    it 'returns unauthorized' do
      request.call
      expect(response).to have_http_status :unauthorized
    end
  end


  # CURRENTLY needs the ID...
  describe '#show' do
    let(:request) { proc { get path }}
    let(:path) { '/api/current_user' }

    describe 'when unauthorized' do
      it_behaves_like 'an unauthorized endpoint'
    end

    describe 'when authorized' do
      before(:each) { sign_in user; request.call }

      it 'returns the current user' do
        expect(response.body).to include user.to_json
      end
    end
  end

  # describe '#update' do end
  # describe '#journals' do end
end