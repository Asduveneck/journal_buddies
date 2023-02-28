class Api::PromptsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_prompt, only: %i[ show update destroy ]
  before_action :set_journal, only: %i[ create ]

  def show
    render json: @prompt
  end

  def create
    @prompt = Prompt.new(permitted_params)
    @prompt.journal = @journal

    if @prompt.save
      render json: @prompt, status: :created #, location: @prompt
    else
      render json: @prompt.errors, status: :unprocessable_entity
    end
  end

  # For now, update/destroy only if prompt has no response
  def update
    render_uneditable_error and return unless @prompt.editable

    if @prompt.update(permitted_params)
      render json: @prompt
    else
      render json: @prompt.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @prompt.destroy
  end

  private
  
  def permitted_params
    params.require(:prompt).permit(
      :journal_id,
      :title,
      :editable,
      :scheduled_date,
    )
  end

  # ?
  def editable_params
    params.require(:prompt).permit(
      :title,
      :editable,
      :scheduled_date
    )
  end

  def set_prompt
    @prompt = Prompt.find(params[:id])
  end

  def set_journal
    @journal = Journal.find(params[:journal_id])
  end

  def editable?
    prompt.editable || params[:editable]
  end

  def render_uneditable_error
    render status :unprocessable_entity, json: { error: "Prompt is uneditable" }
  end

end
