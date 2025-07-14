FactoryBot.define do
  factory :subscription_additional_service do
    association :subscription
    association :additional_service
  end
end
