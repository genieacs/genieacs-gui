class Privilege < ApplicationRecord
  belongs_to :role
  validates :action, presence: true,
                    length: { minimum: 4 }
  validates :weight, presence: true,
                    length: { minimum: 1 }
  validates :resource, presence: true,
                    length: { minimum: 1 }
end
