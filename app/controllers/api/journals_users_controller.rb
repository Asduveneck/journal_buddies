class Api::JournalsUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_journal, only: %i[ show edit create update destroy ]

  # Bulk action to create one or multiple users
  # below should hopefully work
  def create
    return unless @journal.present?
    return unless users.present?

    journals_user_attributes = users.map do |user|
      { user_id: user.user_id, journal_id: @journal.id, user_role: user.role }
    end

    begin
      JournalsUser.transaction do
        @journals_users = JournalsUser.create! journals_user_attributes
      end
    rescue => exception
      @journals_users = {
        error: {
          status: :unprocessable_entity,
          message: exception
        }
      }
    end

    render json: @kournals_users
  end

  def show
    return unless @journal.present?

    render json: @journal.journals_users
  end

  # TODO: find the journal users in the parameter
  def update
    return unless @journal.present?

    journals_user_attributes = users.map do |user|
      { user_id: user.user_id, journal_id: @journal.id, user_role: user.role }
    end
    grouped_journals_users = journals_user_attributes.index_by { |user| user[:user_id] }

    # redo to render update
    # issue is the JournalsUser is a join table with no primary key
    JournalsUser.update(grouped_journals_users.keys, grouped_journals_users.values)
  end

  # TODO: find the journal users in the parameter
  def destroy
    return unless @journal.present?

  end

  private
  
  def journal_params
    params.require(:journal).permit(
      :name,
      users: %i[user_id, role],
    )
  end

  def set_journal
    @journal = Journal.find_by(id: params[:id])
    # raise ActiveRecord::RecordNotFound unless @journal # happens if just use .find
    render(status: 404, inline: 'Journal not found') unless @journal
  end

  def users
    @users ||= params[:users]
  end
end
