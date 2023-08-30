require 'rails_helper'

RSpec.describe Api::CurrentUsers::JournalsController, type: :request do
  include Devise::Test::IntegrationHelpers
  let(:user) {
    create(:user, first_name: 'John', last_name: 'Smith', password: 'password')
  }
  let(:user_id) { user.id }
  let(:user_params) { nil }
  let(:path) { nil }
  let(:request) { proc { return nil } }


  RSpec.shared_examples 'an unauthorized endpoint' do
    it 'returns unauthorized' do
      request.call
      expect(response).to have_http_status :unauthorized
    end
  end


  # need to create journal users and journals
    # [x] test when not signed in
    # [x] test when there are no journal users at all
    # [ ] test when there are journal users
      # it returns all journals the user is participating in

  describe '#index' do
    let(:request) { proc { get path }}
    let(:path) { '/api/current_users/journals' }

    describe 'when unauthorized' do
      it_behaves_like 'an unauthorized endpoint'
    end


    describe 'when authorized' do
      before(:each) { sign_in user; request.call }

      describe 'and the user has no journals' do
        it 'returns the journals' do
          expect(response.body).to include user.journals.to_json
        end
      end
    end
  end
end
