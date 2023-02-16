require 'rails_helper'

RSpec.describe Api::JournalsController, type: :request do
  include Devise::Test::IntegrationHelpers
  let(:user) { create(:user, first_name: 'John', last_name: 'Smith', password: 'password') }

  describe 'when not signed in' do
    describe '#create' do
      it 'returns unauthorized' do
        post '/api/journals', :params => { :journal => {name: 'My journal', description: 'How am I?' } }
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
        it 'returns unprocessable' do
          post '/api/journals', :params => { :journal => {name: '', description: 'How am I?' } }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      # describe 'with valid params' do

      # end
    end
  end

  describe 'when signed in' do
  end
end
