class JournalsUser < ApplicationRecord
  belongs_to :journal
  belongs_to :user

  enum :user_role, USER_ROLES,  _prefix: :user_role
  USER_ROLES = { admin: 'admin', prompt_writer: 'prompt_writer', participant: 'participant', viewer: 'viewer' }.freeze
end