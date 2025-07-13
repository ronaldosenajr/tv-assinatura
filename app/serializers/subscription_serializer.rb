class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :client_id, :plan_id, :package_id

  belongs_to :client
  belongs_to :plan
  belongs_to :package
  has_many :additional_services
end
