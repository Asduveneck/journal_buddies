require 'rails_helper'

RSpec.describe Api::JournalsController, type: :request do
  include Devise::Test::IntegrationHelpers
  let(:user) { create(:user, first_name: 'John', last_name: 'Smith', password: 'password') }
  let(:journal_params) { {name: 'My journal', description: 'How am I?'} }
  let(:request) { proc { return nil } }

  RSpec.shared_examples 'an unauthorized endpoint' do
    it 'returns unauthorized' do
      request.call
      expect(response).to have_http_status :unauthorized
    end
  end

  # an existing journal
  RSpec.shared_examples 'an existing journal' do
    before(:each) { sign_in user; request.call }

    it 'returns status okay' do
      expect(response).to have_http_status :ok
    end
  end

  RSpec.shared_examples 'a nonexistent journal' do
    before(:each) { sign_in user; request.call }

    it 'returns status not found' do
      expect(response).to have_http_status :not_found
    end
  end

  describe '#create' do
    let(:request) { proc { post '/api/journals', params: { journal: journal_params } } }

    describe 'when not signed in' do
      it_behaves_like 'an unauthorized endpoint'
    end

    describe 'with invalid params' do
      let(:journal_params) { {name: '', description: 'How am I?' } }
      before(:each) { sign_in user; request.call }

      it 'returns unprocessable' do
        expect(response).to have_http_status :unprocessable_entity
      end
    end

    describe 'with valid params' do
      let(:journal_params) { {name: 'My journal', description: 'How am I?'} }
      before(:each) { sign_in user; request.call }

      it 'returns status okay' do
        expect(response).to have_http_status :ok
      end

      it 'creates the journal and returns the data' do
        expect(response.content_type).to eq 'application/json; charset=utf-8'
        expect(response.body).to include journal_params[:name]
        expect(response.body).to include journal_params[:description]
      end
    end
  end

  describe '#show' do
    let(:journal) { create(:journal, name: 'First journal') }
    let(:journal_id) { nil }
    let(:request) { proc { get "/api/journals/#{journal_id}" } }

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
      it_behaves_like 'an existing journal'

      before(:each) { sign_in user; request.call }

      it 'returns the journal json' do
        expect(response.body).to include journal.to_json
      end
    end
  end

  describe '#update' do
    let(:journal) { create(:journal, name: 'First journal') }
    let(:journal_id) { nil }
    let(:journal_params) { {name: 'My new journal', description: 'Updated description'} }
    let(:request) { proc { put "/api/journals/#{journal_id}", params: { journal: journal_params }  } }

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
      it_behaves_like 'an existing journal'

      before(:each) { sign_in user; request.call }

      it 'returns the journal with the updated values' do
        expect(response.content_type).to eq 'application/json; charset=utf-8'
        expect(response.body).to include "#{journal.id}"
        expect(response.body).to include journal_params[:name]
        expect(response.body).to include journal_params[:description]
      end
    end
  end

  describe '#destroy' do
  # may need to create journal each time...
    let(:journal) { create(:journal, name: 'First journal') }
    let(:journal_id) { nil }
    let(:request) { proc { delete "/api/journals/#{journal_id}" } }

    describe 'when not signed in' do
      let(:journal_id) { journal.id }
      it_behaves_like 'an unauthorized endpoint'
    end

    describe 'with an invalid journal ID' do
      let(:journal_id) { 'bad_id' }
      it_behaves_like 'a nonexistent journal'
    end

    describe 'with a valid journal id' do
      # let(:journal) { create(:journal, name: 'First journal') }
      let(:journal_id) { journal.id }
      it_behaves_like 'an existing journal'
    end
  end
end