class User < ApplicationRecord
    has_many :journals, through: :journals_users
end
