class User < ApplicationRecord
  DISPLAY_FILEDS = ["username", "email", "expired_at"]
  has_paper_trail

  devise :database_authenticatable, :recoverable, :rememberable, :validatable,
   :registerable, :timeoutable, authentication_keys: [:username]

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

  def timeout_in
    unless self.expired_at.blank?
      ActiveSupport::Duration.build((self.expired_at - DateTime.now).to_i)
    else
      super()
    end
  end
end
