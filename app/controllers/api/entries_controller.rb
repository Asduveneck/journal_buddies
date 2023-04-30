class Api::EntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_prompt, only: %i[ create show update destroy ]
  before_action :set_entry, only: %i[ show update destroy ]


  # TODO: who can see the entries? journal users only?
  # going to start simpler then update for journals users
  def show
    render json: @entry
  end

  def create
    return unless @prompt
    @entry = Entry.new(permitted_params)
    @entry.prompt = @prompt
    @entry.user = user

    if @entry.save
      render json: @entry, status: :created
    else
      render json: @entry.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    render_not_found('Entry') and return unless @entry
    render_not_found('Prompt') and return unless @prompt
    # TODO: fix shortly
    # render_invalid_user_error and return unless entry_user?
    render_uneditable_error and return unless editable?
    
    if @entry.update(editable_params)
      render json: @entry
    else
      render json: @entry.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    render_not_found('Entry') and return unless @entry
    render_not_found('Prompt') and return unless @prompt

    destroyed_entry = @entry.destroy
    if destroyed_entry.destroyed?
      render json: destroyed_entry, status: :ok
    else
      render json: destroyed_entry.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def set_entry
    @entry = Entry.find_by(id: params[:id])
    render_not_found('Entry') unless @entry
  end

  def set_prompt
    @prompt = Prompt.find_by(id: params[:prompt_id])
    render_not_found('Prompt') unless @prompt
  end

  def render_not_found(entity_name)
    render json: { error: "#{entity_name} not found" }, status: :not_found
  end

  def permitted_params
    params.require(:entry).permit(
      :prompt_id,
      # :user_id,
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
    @entry.editable || params[:entry][:editable]
  end

  def render_invalid_user_error
    render json: { error: 'Invalid user' }, status: :unauthorized
  end

  def render_uneditable_error
    render json: { error: 'Entry is uneditable' }, status: :unprocessable_entity
  end
end
