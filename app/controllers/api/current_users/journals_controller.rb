module Api
  module CurrentUsers
    class JournalsController < ApplicationController
      before_action :authenticate_user!

      def index
        render json: current_user.journals.to_json, status: :ok
      end
    end
  end
end