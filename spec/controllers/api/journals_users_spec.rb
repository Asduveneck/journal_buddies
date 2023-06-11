require 'rails_helper'

# TODO:
# unhappy edge cases are put off for now since we will implement policies soon
# and probably will need to set up Faker and more FactoryBot Factories to eliminate some cruft here
# Warning: going to be very lightweight as all the controllers will need updates for policies
# or will be assumed to have correct policies...

RSpec.describe Api::JournalsUsersController, type: :request do
  include Devise::Test::IntegrationHelpers
  let(:user) { create(:user, first_name: 'John', last_name: 'Conner', email: 'jconner@gmail.com', password: 'password') }
  let(:user_two) { create(:user, first_name: 'Sarah', last_name: 'Snow', email: 'ssnow@gmail.com', password: 'password') }
  let(:journal) { create(:journal, name: 'My journal', description: 'How am I?')}
  let(:journal_user) { nil }
  let(:journal_user_two ) { nil }
  let(:journals_users ) { [] }
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

    describe 'when not signed in' do
      it_behaves_like 'an unauthorized endpoint'
    end

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
        expect(response.body).to include 'participant'
      end
    end

    # TODO: invalid user role test?
  end

  describe '#index' do
    # TODO: eliminate the let! and replace create with build_stubbed...
    let(:journal_id) { journal.id }
    let!(:journal_user) { create(:journals_user, :as_admin, user_id: user.id, journal_id: journal.id) }
    let!(:journal_user_two ) { create(:journals_user, :as_participant, user_id: user_two.id, journal_id: journal.id) }
    let(:journals_users) { [journal_user, journal_user_two] }

    let(:request) { proc { get "/api/journals/#{journal_id}/journals_users" } }

    describe 'when not signed in' do
      let(:journal_id) { journal.id }
      it_behaves_like 'an unauthorized endpoint'
    end

    describe 'with an invalid journal ID' do
      let(:journal_id) { 'bad_id' }
      it_behaves_like 'a nonexistent journal'
    end

    describe 'with a valid journal id' do
      let(:journal_id) { journal.id }

      before(:each) { sign_in user; request.call }

      it 'returns the journal users json' do
        expect(response.body).to include journals_users.to_json
      end
    end
  end

  describe '#update' do
    let(:journal_id) { journal.id }
    let(:journal_user) { create(:journals_user, :as_admin, user_id: user.id, journal_id: journal.id) }
    let(:journal_user_two ) { create(:journals_user, :as_participant, user_id: user_two.id, journal_id: journal.id) }
    let(:journals_users_params) { [] }

    let(:request) { proc { patch "/api/journals/#{journal_id}/journals_users", params: { users: journals_users_params } } }

    describe 'when not signed in' do
      let(:journal_id) { journal.id }
      it_behaves_like 'an unauthorized endpoint'
    end

    describe 'with an invalid journal ID' do
      let(:journal_id) { 'bad_id' }
      it_behaves_like 'a nonexistent journal'
    end

    # TODO: test response when invalid role given
    describe 'with a valid journal' do
      describe 'and with all valid new roles' do
        let(:journals_users_params) do
          [
            {journal_user_id: journal_user.id, role: 'viewer'},
            {journal_user_id: journal_user_two.id, role: 'viewer'},
          ]
        end

        before(:each) { sign_in user; request.call }

        it 'returns ok' do
          expect(response).to have_http_status :ok
        end

        it 'returns the journal users with new roles' do
          expect(response.content_type).to eq 'application/json; charset=utf-8'
          expect(response.body).to include "#{journal_user.id}"
          expect(response.body).to include "#{journal_user_two.id}"
          expect(response.body).to include 'viewer'
          expect(response.body).not_to include 'admin'
          expect(response.body).not_to include 'participant'
        end

        it 'updates all of the specified journal users' do
          # test the outdated values before reloading them
          expect(journal_user.user_role).to eq 'admin'
          expect(journal_user_two.user_role).to eq 'participant'
          journal_user.reload
          journal_user_two.reload
          expect(journal_user.user_role).to eq 'viewer'
          expect(journal_user_two.user_role).to eq 'viewer'
        end
      end

      describe 'and with an invalid role' do
        let(:journals_users_params) do
          [
            {journal_user_id: journal_user.id, role: 'viewer'},
            {journal_user_id: journal_user_two.id, role: 'administrator'},
          ]
        end

        # not surfacing the error! or no error!
        it 'returns unprocessable entity' do
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'does not update ANY of the journal users' do
          journal_user.reload
          journal_user_two.reload
          expect(journal_user.user_role).to eq 'admin'
          expect(journal_user_two.user_role).to eq 'participant'
        end
      end
    end
  end
end