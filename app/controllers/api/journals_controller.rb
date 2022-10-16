class Api::JournalsController < ApplicationController
  # def create
  # end

  # def show
  # end

  # def update
  # end

  private
  
  def permitted_params
    params.require(:journal).permit(
      :name,
      :description,
      :user_id,
    )
  end
end
