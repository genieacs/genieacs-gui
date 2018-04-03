class City < ApplicationRecord
  has_paper_trail

  belongs_to :department
  belongs_to :division
  belongs_to :sector_city
  has_many :offices, dependent: :destroy

  validates :code, :name, presence: true, uniqueness: { case_sensitive: true }
end
