class Entry < ApplicationRecord
  belongs_to :prompt
  belongs_to :user
end
