class Api::JournalsUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_journal, only: %i[ show edit update destroy ]

  def create
    return unless @journal.present?
  end

  def show
    return unless @journal.present?
  end


  # update - only users with permitted roles should be able to update but for now...
  def update
    return unless @journal.present?

  end

  # safety checks needed
  def destroy
    return unless @journal.present?

  end

  private
  
  def journal_params
    params.require(:journal).permit(
      :name,
      :description,
      :user_id,
    )
  end

  def set_journal
    @journal = Journal.find_by(id: params[:id])
    # raise ActiveRecord::RecordNotFound unless @journal # happens if just use .find
    render(status: 404, inline: 'Journal not found') unless @journal
  end
end
