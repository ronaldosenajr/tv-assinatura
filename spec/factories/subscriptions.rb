FactoryBot.define do
  factory :subscription do
    client

    trait :with_plan do
      plan
    end

    trait :with_package do
      package
    end

    trait :with_additional_services do
      transient do
        services_count { 1 }
      end

      after(:create) do |subscription, evaluator|
        services = create_list(:additional_service, evaluator.services_count)
        subscription.additional_services << services
      end
    end
  end
end
