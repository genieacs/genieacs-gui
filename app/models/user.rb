class User < ActiveRecord::Base
  has_many :user_roles, class_name:   "UserRole",
                        dependent:    :destroy
  has_many :roles, through: :user_roles
end
