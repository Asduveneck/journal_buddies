class Api::JournalsUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_journal, only: %i[ show edit create update destroy ]

  # Bulk action to create one or multiple users
  # below should hopefully work
  def create
    return unless @journal.present?
    return unless users.present?

    journals_user_attributes = users.map do |user|
      { user_id: user[:user_id], journal_id: @journal.id, user_role: user[:role] }
    end

    begin
      JournalsUser.transaction do
        @journals_users = JournalsUser.create! journals_user_attributes
      end
      render json: @journals_users, status: :created
    rescue => exception
      @journals_users = {
        error: {
          status: :unprocessable_entity,
          message: exception
        }
      }
      render json: @journals_users, status: :unprocessable_entity
    end
  end

  # TODO: isn't this more of an index?!?
  def show
    return unless @journal.present?

    render json: @journal.journals_users
  end

  def update
    return unless @journal.present?

    grouped_journals_users = {}
    users.map do |user|
      grouped_journals_users[user.journal_user_id] = { user_role: user.role }
    end

    begin
      JournalsUser.transaction do
        @journals_users = JournalsUser.update(grouped_journals_users.keys, grouped_journals_users.values)
      end
    rescue => exception
      @journals_users = {
        error: {
          status: :unprocessable_entity,
          message: exception
        }
      }
    end

    render json: @journals_users
  end

  def destroy
    return unless @journal.present?

    @journals_users = JournalsUser.where(journal_id: @journal.id).where(id: users.pluck(:journal_user_id))
    @journals_users.delete

  end

  private
  
  def journal_params
    params.require(:journal).permit(
      :name,
      users: %i[user_id, role, journal_user_id],
    )
  end

  def set_journal
    @journal = Journal.find_by(id: params[:journal_id])
    # raise ActiveRecord::RecordNotFound unless @journal # happens if just use .find
    render json: { error: 'Journal not found' }, status: :not_found unless @journal
  end

  def users
    @users ||= params[:users]
  end
end
