# Draft class to restrict who can view, edit, or delete journals
# In short, a journal can be viewed by any participant, or anyone if the journal is public
# a journal can only be deleted/edited by an admin for that journal

# TODOS:
# [x] 1. simplify the user_role to be a string / enum 
# [x] 2. make the visibility to be a boolean. Visible or private.
# [x] 3. helper for user_role == 'admin' haha.
# [ ] 4. Replace the string with a constant from the model... (here and elsewhere)
# [ ] 5. Double check these policies and roles...


class JournalsPolicy
  def initialize(journal, user, journals_users)
    @journal = journal
    @user = user
    @journals_users = journals_users
  end

  def show?
    return true if @journal.public?
    
    return user_in_journals_users?
  end

  def delete?
    return false unless user_in_journals_users?

    return admin_user_role?
  end

  def edit?
    return false unless user_in_journals_users?

    return admin_user_role?
  end

  def add_user?
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
    @user_role == 'admin'
  end
end