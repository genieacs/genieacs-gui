class Office < ApplicationRecord
  has_paper_trail

  has_many :users, dependent: :nullify
  belongs_to :department
  belongs_to :division
  belongs_to :sector_city
  belongs_to :city

  validates :code, :name, presence: true, uniqueness: { case_sensitive: true }
end
