class PackageSerializer < ActiveModel::Serializer
  attributes :id, :name, :value

  belongs_to :plan
  has_many :additional_services
end
