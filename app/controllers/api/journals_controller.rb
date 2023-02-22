class Api::JournalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_journal, only: [:show, :edit, :update, :destroy]

  def create
    @journal = Journal.new(journal_params)

    if @journal.save
      # Testing right now. Clean up / consolidate errors
      # janky
      journals_user = JournalsUser.new(journal_id: @journal.id, user_id: current_user.id)
      journals_user.save
      render json: @journal, status: :ok
    else
      render json: @journal.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show
    return unless @journal.present?

    render json: @journal, status: :ok
  end

  def edit
  end

  # update - only users with permitted roles should be able to update but for now...
  def update
    if @journal.update(journal_params)
      render json: @journal, status: :ok
    else
      render json: @json.errors.full_messages, status: :unprocessable_entity
    end
  end

  # safety checks needed
  def destroy
    @journal.destroy
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
    render(status: 404, inline: "Journal not found") unless @journal
  end
end
