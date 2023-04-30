class Api::PromptsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_journal, only: %i[ create show update destroy ]
  before_action :set_prompt, only: %i[ show update destroy ]

  # TODO: who should be able to see? journals users?
  def show
    render json: @prompt 
  end

  def create
    return unless @journal

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
    # the render should happen in the set_prompt / set_journal
    render_not_found('Journal') and return unless @journal
    render_not_found('Prompt') and return unless @prompt
    render_uneditable_error and return unless (@prompt.editable || editable_params[:editable] )

    if @prompt.update(permitted_params)
      render json: @prompt
    else
      render json: @prompt.errors, status: :unprocessable_entity
    end
  end

  def destroy
    render_not_found('Journal') and return unless @journal
    render_not_found('Prompt') and return unless @prompt

    destroyed_prompt = @prompt.destroy

    if destroyed_prompt.destroyed?
      render json: destroyed_prompt, status: :ok
    else
      render json: destroyed_prompt.errors.full_messages, status: :unprocessable_entity
    end
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
    @prompt = Prompt.find_by(id: params[:id])
    render_not_found('Prompt') unless @prompt
  end

  def set_journal
    @journal = Journal.find_by(id: params[:journal_id])
    render_not_found('Journal') unless @journal
  end

  def editable?
    prompt.editable || params[:editable]
  end

  def render_uneditable_error
    render json: { error: 'Prompt is uneditable' }, status: :unprocessable_entity
  end

  def render_not_found(entity_name)
    render json: { error: "#{entity_name} not found" }, status: :not_found
  end
end
