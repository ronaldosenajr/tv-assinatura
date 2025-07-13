class Plan < ApplicationRecord
  has_many :packages
  validates :name, presence: true
  validates :value, presence: true, numericality: true
end
