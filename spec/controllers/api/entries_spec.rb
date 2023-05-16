require 'rails_helper'

RSpec.describe Api::PromptsController, type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) {
    create(:user, first_name: 'John', last_name: 'Smith', password: 'password')
  }
  let(:user_id) { user.id }
  let(:journal) {
    create(:journal, name: 'My journal', description: 'How am I?')
  }
  let(:prompt) { create(:prompt, title: 'How are you?', journal_id: journal.id, editable: true) }
  let(:prompt_id) { prompt.id }
  let(:entry) { create(:entry, text_content: 'I am fine.', user_id: user.id, editable: true, prompt_id: prompt.id) }
  let(:entry_id) { entry.id }
  let(:text_content) { nil }
  let(:editable) { nil }

  let (:valid_params) {
    {
      entry: {
        text_content: text_content,
        editable: editable,
      }
    }
  }

  let(:path) { nil }
  let(:request) { proc { return nil } }

  RSpec.shared_examples 'an authorized endpoint' do
    it 'returns unauthorized' do
      request.call
      expect(response).to have_http_status :unauthorized
    end
  end

  RSpec.shared_examples 'a nonexistent prompt' do
    before(:each) { sign_in user; request.call }

    it 'returns status not found' do
      expect(response).to have_http_status :not_found
    end
  end

  RSpec.shared_examples 'a nonexistent entry' do
    before(:each) { sign_in user; request.call }

    it 'returns status not found' do
      expect(response).to have_http_status :not_found
    end
  end

  RSpec.shared_examples 'an existing prompt and entry' do
    before(:each) { sign_in user; request.call }

    it 'returns status okay' do
      puts response.body; puts text_content
      expect(response).to have_http_status :ok
    end
  end

  describe '#show' do
    let(:request) { proc { get path, params: valid_params } }
    let(:path) { "/api/prompts/#{prompt_id}/entries/#{entry_id}" }

    describe 'when unauthorized' do
      it_behaves_like 'an authorized endpoint'
    end

    describe 'with a nonexistent prompt' do
      let(:prompt_id) { 'bad' }
      it_behaves_like 'a nonexistent prompt'
    end

    describe 'with an existent prompt ID' do
      describe 'with a nonexistent entry ID' do
        let(:entry_id) { 'bad' }
        it_behaves_like 'a nonexistent entry'
      end

      describe 'with a valid entry ID' do
        it_behaves_like 'an existing prompt and entry'

        before(:each) { sign_in user; request.call}

        it 'returns the entry json' do
          expect(response.body).to include entry.to_json
        end
      end
    end
  end

  describe '#update' do
    let(:request) { proc { put path, params: valid_params } }
    let(:path) { "/api/prompts/#{prompt_id}/entries/#{entry_id}" }

    describe 'when unauthorized' do
      it_behaves_like 'an authorized endpoint'
    end

    describe 'with a nonexistent prompt' do
      let(:prompt_id) { 'bad' }
      it_behaves_like 'a nonexistent prompt'
    end

    describe 'with an existent prompt ID' do
      describe 'with a nonexistent entry ID' do
        let(:entry_id) { 'bad' }
        it_behaves_like 'a nonexistent entry'
      end

      # RSpec.shared_examples 'a non-updatable entry' do
      #   it 'renders unprocessable entity'
      #   it 'returns a message stating the entry is uneditable'
      #   it 'does not update the entry'
      #   it 'only updates when setting it to be editable'
      # end

      RSpec.shared_examples 'an updatable entry' do
        before(:each) { sign_in user; request.call }

        it 'renders success' do
          expect(response).to have_http_status :ok
        end

        it 'updates the entry' do
          entry.reload
          expect(entry.text_content).to eq text_content
        end

        it 'returns the updated entry' do
          entry.reload
          expect(JSON.parse(response.body)).to eq JSON.parse(entry.to_json)
        end

      end

      describe 'with a valid entry ID and the corresponding user ID' do
        let(:original_text) { 'I am fine' }
        before(:each) { sign_in user; request.call }

        describe 'but a not editable entry' do
          let(:entry) { create(:entry, text_content: original_text, user_id: user.id, editable: false, prompt_id: prompt.id) }
          let(:text_content) { 'I really am fine.' }
          before(:each) { sign_in user; request.call }

          it 'responds with unprocessable entity' do
            expect(response).to have_http_status :unprocessable_entity
          end

          it 'returns a message stating the entry is uneditable' do
            expect(response.body).to include 'Entry is uneditable'
          end

          it 'does not update the entry' do
            entry.reload
            expect(entry.text_content).to eq original_text
          end

          describe 'when setting the entry to editable' do
            let(:editable) { true }

            it_behaves_like 'an updatable entry'
          end
        end

        describe 'and it is editable' do
          let(:entry) { create(:entry, text_content: original_text, user_id: user.id, editable: true, prompt_id: prompt.id) }
          let(:text_content) { 'I really am fine.' }
          let(:editable) { true } # needed for the individual specs within the it

          it_behaves_like 'an updatable entry'
        end
      end

      # on hold
      describe 'with a valid entry ID but a different user ID' do
        # it_behaves_like 'an existing prompt and entry'

        before(:each) { sign_in user; request.call}

        # it 'returns unprocessable'
        # it 'does not update the entry'
      end
    end
  end
end
