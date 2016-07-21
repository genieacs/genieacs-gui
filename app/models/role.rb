class Role < ApplicationRecord
  has_many :user_roles, class_name:   "UserRole",
                        dependent:    :destroy
  has_many :users, through: :user_roles
  has_many :privileges, dependent: :destroy
  validates :name, presence: true,
                    length: { minimum: 1 }
end
