class Api::JournalsController < ApplicationController
  def create
    @journal = Journal.new(permitted_params)

    if @journal.save
      render @journal.to_json
    else
      render json: @journal.errors.full_messages, status :unprocessable_entity
    end
  end

  def show
    render @journal.to_json
  end

  # update - only users with permitted roles should be able to

  private
  
  def permitted_params
    params.require(:journal).permit(
      :name,
      :description,
      :user_id,
    )
  end
end
