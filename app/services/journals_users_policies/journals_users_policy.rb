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
    return admin_user_role?
  end

  def delete?
    return admin_user_role?
  end

  def edit?
    return admin_user_role?
  end

  private

  def journal_user
    @journal_user ||= @journals_users.include(have_attributes(user_id: @user.id))
  end

  def user_in_journals_users?
    @user_in_journals_users? ||= @journal_user.present?
  end

  def user_role
    @user_role ||= @journal_user&.role || ''
  end

  def admin_user_role?
    @admin_user_role? ||= @user_role == 'admin'
  end
end