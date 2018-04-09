class UserRole < ApplicationRecord
  has_paper_trail

  belongs_to :user, optional: true
  belongs_to :role, optional: true
end
