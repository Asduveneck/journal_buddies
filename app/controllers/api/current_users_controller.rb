class Api::CurrentUsersController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: current_user, status: :ok
  end

  def update
    # may need to double check current user vs user params
    if current_user.update(user_params)
      render json: current_user, status: :ok
    else
      render json: current_user.errors.full_messages, status: :unprocessable_entity
    end
  end

  # an index method for all the journals associated with the user
  def journals
    render json: current_user.journals, status: :ok
  end

  private
  
  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      # :user_name
    )
  end
end