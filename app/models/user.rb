class User < ApplicationRecord

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable,
   :registerable, authentication_keys: [:username]

  has_many :user_roles, class_name: "UserRole", dependent: :destroy
  has_many :roles, through: :user_roles

  validates :username,
            presence: true, length: { minimum: 1 },
            uniqueness: { case_sensitive: false }

  def email_required?
    false
  end

  def password_required?
    return false unless self.new_record?

    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
