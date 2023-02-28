require 'rails_helper'

RSpec.describe Api::PromptsController, type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) {
    create(:user, first_name: 'John', last_name: 'Smith', password: 'password')
  }
  let(:journal) {
    create(:journal, name: 'My journal', description: 'How am I?')
  }

  let(:title) { nil}
  let(:editable) { nil}
  let(:scheduled_date) { nil}

  let (:valid_params) {
    {
      prompt: {
        title: title,
        editable: editable,
        scheduled_date: scheduled_date
      }
    }
  }

  describe '#create' do
    let(:journal_id) { nil }
    let(:path) { "/api/journals/#{journal_id}/prompts" }

    describe 'with valid params and a valid journal' do
      let(:journal_id) { journal.id }
      let(:title) { 'How was your week?' }
      let(:editable) { true }
      let(:scheduled_date) { Date.new }

      before(:each) { sign_in user }


      it 'returns status created' do
        post path, params: valid_params

        expect(response).to have_http_status :created
      end
    end
  end
end
