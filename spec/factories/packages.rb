FactoryBot.define do
  factory :package do
    name { "Pacote Bronze" }
    plan
    value { nil } # será calculado no before_validation, se for nil

    trait :with_additional_services do
      transient do
        services_count { 2 }
      end

      after(:create) do |package, evaluator|
        services = create_list(:additional_service, evaluator.services_count)
        package.additional_services << services
        package.update(value: package.calculate_value) if package.value.nil?
      end
    end
  end
end
