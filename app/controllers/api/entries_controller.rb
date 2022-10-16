class Api::EntriesController < ApplicationController
  # pseudo code (env not fully configured)
  # do we need all the @?
  def create
    @entry = Entry.new(permitted_params)

    if @entry.save
      render @entry.to_json
    else
      render json: @entry.errors.full_messages, status :unprocessable_entity,
    end
  end

  def show
    render @entry.to_json
  end

  def update
    render_invalid_user_error and return unless entry_user?

    render_uneditable_error and return unless editable?
    
    if entry.update_attributes(editable_params)
      render @entry.to_json
    else
      render json: @entry.errors.full_messages, status :unprocessable_entity,
    end
  end

  def destroy
    @entry.destroy
    render json: @entry.to_json
  end

  private

  # not sure if this will work.
  # no routes, db, working yet
  def entry
    @entry = Entry.find(params[:id])
  end
  
  def permitted_params
    params.require(:entry).permit(
      :prompt_id,
      :user_id,
      :editable,
      :text_content,
    )
  end

  def editable_params
    params.require(:entry).permit(
      :editable,
      :text_content
    )
  end

  def entry_user?
    params[:user_id] == @entry.user_id.to_s
  end

  def editable?
    entry.editable || params[:editable]
  end

  def render_invalid_user_error
    render status :unauthorized, json: { error: 'You are not allowed to edit other people\'s responses' }
  end

  def render_uneditable_error
    render status :unprocessable_entity, json: { error: 'Entry is locked. Unlock to try again' }
  end
end
