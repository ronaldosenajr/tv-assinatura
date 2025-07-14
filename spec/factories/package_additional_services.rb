FactoryBot.define do
  factory :package_additional_service do
    association :package
    association :additional_service
  end
end
