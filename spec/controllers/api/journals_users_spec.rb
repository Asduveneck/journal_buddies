require 'rails_helper'

# Warning: going to be very lightweight as all the controllers will need updates for policies
# or will be assumed to have correct policies...

RSpec.describe Api::JournalsController, type: :request do
  include Devise::Test::IntegrationHelpers
  let(:user) { create(:user, first_name: 'John', last_name: 'Conner', email: 'jconner@gmail.com', password: 'password') }
  let(:user_two) { create(:user, first_name: 'Sarah', last_name: 'Snow', email: 'ssnow@gmail.com', password: 'password') }
  let(:journal) { create(:journal, name: 'My journal', description: 'How am I?')}
  let(:request) { proc { return nil } }
  let(:journals_users_params) { [] }

  RSpec.shared_examples 'an unauthorized endpoint' do
    it 'returns unauthorized' do
      request.call
      expect(response).to have_http_status :unauthorized
    end
  end

  RSpec.shared_examples 'a nonexistent journal' do
    before(:each) { sign_in user; request.call }

    it 'returns status not found' do
      expect(response).to have_http_status :not_found
    end
  end

  describe '#create' do
    let(:journal_id) { journal.id }
    let(:request) { proc { post "/api/journals/#{journal_id}/journals_users", params: { users: journals_users_params } } }

    describe 'with valid params' do
      let(:journals_users_params) {
        [
          {user_id: user.id, role: 'admin'},
          {user_id: user_two.id, role: 'participant' }
        ]
      }

      before(:each) { sign_in user; request.call }

      it 'returns status created' do
        expect(response).to have_http_status :created
      end

      it 'creates the journal users and returns the data' do
        expect(response.content_type).to eq 'application/json; charset=utf-8'
        expect(response.body).to include 'admin'
      end

    end
  end
end