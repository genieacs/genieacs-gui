class Division < ApplicationRecord
  has_paper_trail

  has_many :sector_cities, dependent: :destroy
  has_many :cities, dependent: :destroy
  has_many :offices, dependent: :destroy
  belongs_to :department

  validates :code, :name, presence: true, uniqueness: { case_sensitive: true }
end
