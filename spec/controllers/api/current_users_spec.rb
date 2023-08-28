require 'rails_helper'

RSpec.describe Api::CurrentUsersController, type: :request do
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


  # CURRENTLY needs the ID...
  describe '#show' do
    let(:request) { proc { get path }}
    let(:path) { '/api/current_users' }

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

  describe '#update' do
    let(:path) { '/api/current_users' }
    let(:user_params) {{first_name: 'Hans', last_name: 'Elm'}}

    let(:request) { proc { put path, params: { user: user_params } }}

    describe 'when unauthorized' do
      before(:each) { request.call }
      it_behaves_like 'an unauthorized endpoint'
    end

    describe 'when authorized' do
      before(:each) { sign_in user; request.call }

      it 'renders success' do
        expect(response).to have_http_status :ok
      end

      it 'updates the user' do
        user.reload
        expect(user.first_name).to eq user_params[:first_name]
        expect(user.last_name).to eq user_params[:last_name]
      end

      it 'returns the user with the updated values' do
        expect(response.content_type).to eq 'application/json; charset=utf-8'
        expect(response.body).to include user_params[:first_name]
        expect(response.body).to include user_params[:last_name]
      end
    end
  end

  # describe '#journals' do end
end