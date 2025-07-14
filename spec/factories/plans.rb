FactoryBot.define do
  factory :plan do
    name { "Basic Plan" }
    value { 29.99 }

    trait :free do
      value { 0 }
    end

    trait :premium do
      value { 99.99 }
    end
  end
end
