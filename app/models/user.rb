class User < ApplicationRecord
  has_many :user_roles, class_name:   "UserRole",
                        dependent:    :destroy
  has_many :roles, through: :user_roles
  validates :username, presence: true,
                    length: { minimum: 1 }
  validates :password, presence: true,
                    length: { minimum: 3 }
end
