class Client < ApplicationRecord
    has_many :subscriptions, dependent: :destroy
    validates :name, presence: true
    validates :age, presence: true, numericality: { only_integer: true, greater_than: 17 }
end
