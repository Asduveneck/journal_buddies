require 'rails_helper'

RSpec.describe Api::JournalsController, type: :request do
  include Devise::Test::IntegrationHelpers
  let(:user) { create(:user, first_name: 'John', last_name: 'Smith', password: 'password') }
  let(:journal_params) { {name: 'My journal', description: 'How am I?'} }
  describe 'when not signed in' do
    describe '#create' do
      it 'returns unauthorized' do
        post '/api/journals', :params => { journal: journal_params }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe '#show' do
      let(:journal) { create(:journal, name: 'first journal') }
      let(:journal_params) { nil }

      it 'returns unauthorized' do
        get "/api/journals/#{journal.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'when signed in' do
    before(:each) do
      sign_in user
    end

    describe '#create' do
      describe 'with invalid params' do
        let(:journal_params) { {name: '', description: 'How am I?' } }

        it 'returns unprocessable' do
          post '/api/journals', :params => { :journal => journal_params }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      describe 'with valid params' do
        it 'returns status okay' do
          post '/api/journals', params: { :journal => journal_params }
          expect(response).to have_http_status(:ok)
        end

        it 'creates the journal and returns the data' do
          post '/api/journals', params: { :journal => journal_params }
          expect(response.content_type).to eq("application/json; charset=utf-8")
          expect(response.body).to include(journal_params[:name])
          expect(response.body).to include(journal_params[:description])
        end
      end
    end

    describe '#show' do
      let(:journal) { create(:journal, name: 'first journal') }

      describe 'with an invalid / nonexistent journal' do
        it 'returns status not found' do
          get '/api/journals/bad_id'
          expect(response).to have_http_status(:not_found)
        end
      end

      describe 'with a valid/existing journal' do
        it 'returns status okay' do
          get "/api/journals/#{journal.id}"
          expect(response).to have_http_status(:ok)
        end

        it 'returns the journal json' do
          get "/api/journals/#{journal.id}"
          expect(response.body).to include(journal.to_json)
        end
      end
    end
  end
end
