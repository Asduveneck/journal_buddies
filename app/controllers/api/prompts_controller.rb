class Api::PromptsController < ApplicationController
  # not sure if this will work.
  # refactor based on journals
  def create
    @prompt = Prompt.new(permitted_params)

    if @prompt.save
      render @prompt.to_json
    else
      render json: @prompt.errors.full_messages, status :unprocessable_entity
    end
  end

  def show
    render prompt.to_json if prompt
  end

  # For now, update/destroy only if prompt has no response
  def update
    render_has_entries_error and return if @prompt.entries.present?

    render_uneditable_error and return unless editable?

    if prompt.update_attributes(editable_params)
      render prompt.to_json
    else
      render json: @prompt.errors
  end

  def destroy
    render_has_entries_error and return if @prompt.entries.present?

    prompt.destroy
    render json: prompt.to_json
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

  def editable_params
    params.require(:prompt).permit(
      :title,
      :editable,
      :scheduled_date
    )
  end

  def prompt
    @prompt = prompt.find(params[:id])
  end

  def render_has_entries_error
    render status :unprocessable_entity, json: { error: "Prompt has entries" }
  end

  def editable?
    prompt.editable || params[:editable]
  end

  def render_uneditable_error
    render status :unprocessable_entity, kjon: { error: "Prompt is uneditable" }
end
