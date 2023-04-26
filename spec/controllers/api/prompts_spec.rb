require 'rails_helper'

RSpec.describe Api::PromptsController, type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) {
    create(:user, first_name: 'John', last_name: 'Smith', password: 'password')
  }
  let(:journal) {
    create(:journal, name: 'My journal', description: 'How am I?')
  }
  let(:journal_id) { journal.id }
  let(:prompt) { create(:prompt, title: 'How are you?', journal_id: journal.id, editable: true) }
  let(:prompt_id) { prompt.id }
  let(:title) { nil }
  let(:editable) { nil }
  let(:scheduled_date) { nil }

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

  RSpec.shared_examples 'an authorized endpoint' do
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

   RSpec.shared_examples 'a nonexistent prompt' do
    before(:each) { sign_in user; request.call }

    it 'returns status not found' do
      expect(response).to have_http_status :not_found
    end
  end

  RSpec.shared_examples 'an existing prompt and journal' do
    before(:each) { sign_in user; request.call }

    it 'returns status okay' do
      expect(response).to have_http_status :ok
    end
  end

  describe '#show' do
    let(:request) { proc { get path, params: valid_params } }
    let(:path) { "/api/journals/#{journal_id}/prompts/#{prompt_id}" }

    describe 'when unauthorized' do
      it_behaves_like 'an authorized endpoint'
    end

    describe 'with a nonexistent journal' do
      let(:journal_id) { 'bad' }
      let(:path) { "/api/journals/#{journal_id}/prompts/#{prompt.id}" }

      it_behaves_like 'a nonexistent journal'
    end

    describe 'with a valid journal' do
      describe 'with a nonexistent prompt ID' do
        let(:prompt_id) { 'bad' }
        it_behaves_like 'a nonexistent prompt'
      end

      describe 'with a valid prompt ID' do
        it_behaves_like 'an existing prompt and journal'

        before(:each) { sign_in user; request.call }

        it 'returns the prompt json' do
          expect(response.body).to include prompt.to_json
        end
      end
    end
  end

  describe '#update' do
    let(:request) { proc { put path, params: valid_params } }
    let(:path) { "/api/journals/#{journal_id}/prompts/#{prompt_id}" }

    describe 'when unauthorized' do
      it_behaves_like 'an authorized endpoint'
    end

    describe 'with a nonexistent journal' do
      let(:journal_id) { 'bad' }
      let(:path) { "/api/journals/#{journal_id}/prompts/#{prompt.id}" }

      it_behaves_like 'a nonexistent journal'
    end

    describe 'with a valid journal' do
      describe 'with a nonexistent prompt ID' do
        let(:prompt_id) { 'bad' }
        it_behaves_like 'a nonexistent prompt'
      end

      describe 'with an editable prompt, a valid prompt ID and params' do
        it_behaves_like 'an existing prompt and journal'

        let(:title) { 'How has your week been?'}
        let(:editable) { false }

        it 'returns the prompt with the updated values' do
          sign_in user; request.call
          expect(response.content_type).to eq 'application/json; charset=utf-8'
          expect(response.body).to include "#{prompt.id}"
          expect(response.body).to include title
          expect(response.body).to include "#{editable}"
        end
      end

      describe 'with an uneditable prompt, but valid prompt ID and params' do
        let(:original_title) { 'How are you?' }
        let(:prompt) { create(:prompt, title: original_title, journal_id: journal.id, editable: false) }

        describe 'when not explicitly updating the prompt to be editable' do
          let(:title) { 'New prompt' }
          before(:each) { sign_in user; request.call }

          it 'renders unprocessable entity' do
            expect(response).to have_http_status :unprocessable_entity
          end

          it 'returns a message stating the prompt is uneditable' do
            expect(response.body).to include 'Prompt is uneditable'
          end

          it 'does not update the prompt' do
            prompt.reload
            expect(prompt.title).to eq original_title
          end
        end

        describe 'when explicitly updating the prompt to be editable' do
          let(:title) { 'New prompt' }
          let(:editable) { true }
          before(:each) { sign_in user; request.call }

          it 'renders unprocessable entity' do
            expect(response).to have_http_status :ok
          end

          it 'returns a message stating the prompt is uneditable' do
            expect(response.body).to include title
          end

          it 'updates the prompt' do
            prompt.reload
            expect(prompt.title).to eq title
          end
        end
      end
    end
  end

  # describe '#destroy'

  # TODO: handle recurring prompts for title
  describe '#create' do
    let(:journal_id) { 'bad' }
    let(:path) { "/api/journals/#{journal_id}/prompts" }

    let(:request) { proc { post path, params: valid_params } }

    describe 'when unauthorized' do
      it_behaves_like 'an authorized endpoint'
    end

    describe 'with a nonexistent journal' do
      it_behaves_like 'a nonexistent journal'
    end

    describe 'with a valid journal' do
      let(:journal_id) { journal.id }
      
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
