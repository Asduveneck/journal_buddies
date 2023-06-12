class Api::JournalsUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_journal, only: %i[ index edit create update destroy ]

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

  def index
    return unless @journal.present?

    render json: @journal.journals_users
  end

  def update
    return unless @journal.present?

    grouped_journals_users = {}
    users.map do |user|
      grouped_journals_users[user[:journal_user_id]] = { user_role: user[:role] }
    end

    begin
      JournalsUser.transaction do
        @journals_users = JournalsUser.update(grouped_journals_users.keys, grouped_journals_users.values)
      end
      render json: @journals_users, status: :ok
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

  def destroy
    return unless @journal.present?

    # @journals_users = JournalsUser.where(journal_id: @journal.id).where(id: users.pluck(:journal_user_id)).destroy
    @journals_users = JournalsUser.destroy_by(journal_id: @journal.id, id: users.pluck(:journal_user_id))
    if @journals_users.all? { |journal_user| journal_user.destroyed? }
      render json: @journals_users, status: :ok
    else
      render json: @journals_users.errors.full_messages, status: :unprocessable_entity
    end

  end

  private
  
  # TODO: these params need to be further restricted depending on the method
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
