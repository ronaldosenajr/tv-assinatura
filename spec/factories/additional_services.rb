FactoryBot.define do
  factory :additional_service do
    name { "Streaming Extra" }
    value { 14.90 }

    trait :storage do
      name { "Cloud Storage" }
      value { 9.90 }
    end

    trait :premium_support do
      name { "Premium Support" }
      value { 19.90 }
    end
  end
end
