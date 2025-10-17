class Bill < ApplicationRecord
  belongs_to :subscription
  belongs_to :item, polymorphic: true

  #teste
end
