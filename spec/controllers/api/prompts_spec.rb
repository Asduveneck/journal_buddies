require 'rails_helper'

RSpec.describe Api::PromptsController, type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) {
    create(:user, first_name: 'John', last_name: 'Smith', password: 'password')
  }
  let(:journal) {
    create(:journal, name: 'My journal', description: 'How am I?')
  }
  let(:prompt) { create(:prompt, title: 'How are you?', journal_id: journal) }

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

  let(:path) { nil }
  let(:request) { proc { return nil } }
  # subject { response }

  RSpec.shared_examples 'a nonexistent journal' do
    before(:each) { sign_in user; request.call }

    it 'returns status not found' do
      expect(response).to have_http_status :not_found
    end
  end

  describe '#show' do
    let(:request) { proc { get path, params: valid_params } }
    let(:path) { "/api/journals/#{journal_id}/prompts/#{prompt.id}" }

    describe 'with a nonexistent journal'  do
      let(:journal_id) { 'bad' }
      let(:path) { "/api/journals/#{journal_id}/prompts/#{prompt.id}" }

      # it doesn't/ What behavior do I want here?
      # it_behaves_like 'a nonexistent journal'
    end
    describe 'with a valid journal' do
      describe 'when unauthorized'
      describe 'with an invalid prompt ID'
      describe 'with a valid prompt ID'
    end
  end

  describe '#update' do
   describe 'with a nonexistent journal'  do
      it 'returns not found' do end
    end
    describe 'with a valid journal' do
      describe 'when unauthorized'
      describe 'with an invalid prompt ID'
      describe 'with a valid prompt ID and params' do
        it 'returns the prompt with the updated values'
      end
    end
  end

  # describe '#destroy'


  describe '#create' do
    # what if I explicitly state the journal and path,
    # or try using a proc below here and see if that makes it fail?
    let(:journal_id) { 'bad' }
    let(:path) { "/api/journals/#{journal_id}/prompts" }

    let(:request) { proc { post path, params: valid_params } }

    describe 'with a nonexistent journal' do
      it_behaves_like 'a nonexistent journal'

      # below passes
      # it 'should return not found' do
      #   post path, params: valid_params

      #   expect(response).to have_http_status :not_found
      # end
    end

    describe 'with a valid journal' do
      let(:journal_id) { journal.id }
      
      describe 'when unauthorized' do
        it 'returns unauthorized' do
          post path, params: valid_params
          expect(response).to have_http_status :unauthorized
        end
      end
      
      # NA for now. Needs recurring prompt next; title should be required when no recurring prompt
      # describe 'with invalid params' do
      #   let(:title) { '' }
      #   before(:each) { sign_in user }

      #   it 'returns unprocessable' do
      #     expect(response).to have_http_status :unprocessable_entity
      #   end
      # end

      describe 'with valid params' do
        let(:title) { 'How was your week?' }
        let(:editable) { true }
        let(:scheduled_date) { Date.new }

        before(:each) { sign_in user }

        it 'returns status created' do
          post path, params: valid_params

          expect(response).to have_http_status :created
        end

        it 'creates the prompt and returns the data' do
          post path, params: valid_params

          expect(response.body).to include "#{valid_params[:prompt][:editable]}"
          expect(response.body).to include "#{valid_params[:prompt][:title]}"
          expect(response.body).to include "#{valid_params[:prompt][:scheduled_date]}"
        end
      end
    end
  end


end
