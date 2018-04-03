class SectorCity < ApplicationRecord
  has_paper_trail

  belongs_to :department
  belongs_to :division
  has_many :cities, dependent: :destroy
  has_many :offices, dependent: :destroy

  validates :code, :name, presence: true, uniqueness: { case_sensitive: true }
end
