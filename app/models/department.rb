class Department < ApplicationRecord
  has_paper_trail

  has_many :divisions, dependent: :destroy
  has_many :sector_cities, dependent: :destroy
  has_many :cities, dependent: :destroy
  has_many :offices, dependent: :destroy

  validates :code, :name, presence: true, uniqueness: { case_sensitive: true }
end
