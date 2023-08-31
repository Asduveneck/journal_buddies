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

  describe '#index' do
    let(:request) { proc { get path }}
    let(:path) { '/api/current_users/journals' }

    describe 'when unauthorized' do
      it_behaves_like 'an unauthorized endpoint'
    end


    describe 'when authorized' do
      before(:each) { sign_in user; request.call }

      describe 'and the user has no journals' do
        it 'returns an empty array' do
          expect(response.body).to eq [].to_json
        end
      end

      describe 'and the user has journals' do
        let(:user) {
          create(:user_with_journals, first_name: 'John', last_name: 'Smith', password: 'password', journals_count: 3)
        }
        let(:journal_1) { user.journals.first }
        let(:journal_2) { user.journals.second }
        let(:journal_3) { user.journals.last }

        before(:each) { sign_in user; request.call }

        it 'returns the journals' do
          expect(response.body).to_not be_empty
          expect(response.body).to include user.journals.to_json
          expect(response.body).to include journal_1.to_json
        end
      end
    end
  end
end
