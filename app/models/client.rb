class Client < ApplicationRecord
    validates :name, presence: true
    validates :age, numericality: { only_integer: true, greater_than: 17 }

end
