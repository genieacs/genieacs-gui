# frozen_string_literal: true

class User < ApplicationRecord
  DISPLAY_FILEDS = %w[
    username email expired_at first_name last_name telephone department_id
    division_id sector_city_id city_id office_id
  ].freeze

  has_paper_trail only: [*User::DISPLAY_FILEDS, 'encrypted_password']

  devise :database_authenticatable, :recoverable, :rememberable, :validatable,
         :trackable, :registerable, authentication_keys: [:username]

  has_many :user_roles, class_name: 'UserRole', dependent: :destroy
  has_many :roles, through: :user_roles

  belongs_to :department, optional: true
  belongs_to :division, optional: true
  belongs_to :sector_city, optional: true
  belongs_to :city, optional: true
  belongs_to :office, optional: true

  validates :email, presence: true
  validates :username,
            presence: true, length: { minimum: 1 },
            uniqueness: { case_sensitive: false }

  def password_required?
    return false unless new_record?

    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def active_for_authentication?
    if expired_at.present?
      super && (expired_at > Time.zone.now)
    else
      super
    end
  end
end
