class Plan < ApplicationRecord
  has_many :packages
  has_many :subscriptions, dependent: :nullify
  validates :name, presence: true
  validates :value, presence: true, numericality: true
end
