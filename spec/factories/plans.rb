FactoryBot.define do
  factory :plan do
    value { 9.99 }
  end

  factory :basic_plan, parent: :plan do
    name { "Basic Plan" }
  end

  factory :premium_plan, parent: :plan do
    name { "Premium Plan" }
    value { 29.99 }
  end

  factory :pro_plan, parent: :plan do
    name { "Pro Plan" }
    value { 59.99 }
  end
end
