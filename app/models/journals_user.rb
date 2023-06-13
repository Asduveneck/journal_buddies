class JournalsUser < ApplicationRecord
  belongs_to :journal
  belongs_to :user
  validates :journal_id, :user_id, :user_role, presence: true

  USER_ROLES = { admin: 'admin', prompt_writer: 'prompt_writer', participant: 'participant', viewer: 'viewer' }.freeze
  enum :user_role, USER_ROLES,  _prefix: :user_role
  validates :user_role, inclusion: { in: USER_ROLES.values }
end
