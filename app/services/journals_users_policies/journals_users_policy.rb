# Draft class to restrict who can view, edit, or delete journals users
# journals users can be viewed by everyone if the journal is public, or if they are a journal participant
# journals users can be edited by an admin
# journals users can only be added by admin
# journals users can only be deleted by admin

class JournalsUsersPolicy
  def initialize( journal, user, journals_users)
    @journal = journal
    @user = user
    @journals_users = journals_users
  end

  def show?
    return true if @journal.public?
    
    return user_in_journals_users?
  end

  def create?
    # a new journal doesn't have any journal users / restrictions yet.
    return true
  end

  def delete?
    return journal_user.admin?
  end

  def edit?
    return journal_user.admin?
  end

  private

  def journal_user
    @journal_user ||= @journals_users.include(have_attributes(user_id: @user.id))
  end

  def user_in_journals_users?
    @user_in_journals_users? ||= @journal_user.present?
  end
end
