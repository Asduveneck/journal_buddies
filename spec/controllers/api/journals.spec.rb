require 'rails_helper'

RSpec.describe Api::JournalsController, type: :controller do
  describe 'POST #create' do
    let(:params) { nil }

    describe 'with invalid params' do
      it 'does not create a journal' do
        expect(false).to eq(true) # fails but actually runs
      end
    end
  end
end
