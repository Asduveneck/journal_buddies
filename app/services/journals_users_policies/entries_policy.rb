# Draft class to restrict who can view, edit, or delete entries
# entries can be viewed by everyone if the journal is public, or if they are a journal participant
# entries can be edited by only the author
# entries can only be created by participants (maybe...?)
# entries can be deleted by the author or an admin

class EntriesPolicy
  def initialize( journal, user, journals_users, entry)
    @journal = journal
    @user = user
    @journals_users = journals_users
    @entry = entry
  end

  def show?
    return true if @journal.public?
    
    return user_in_journals_users?
  end

  def create?
    return user_in_journals_users?
  end

  def delete?
    return false unless user_in_journals_users?

    return author? || user_role == 'admin'
  end

  def edit?
    return false unless user_in_journals_users?

    return author?
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

  def author?
    @entry.user == @user
  end
end