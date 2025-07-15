FactoryBot.define do
  factory :bill do
    association :subscription
    association :item, factory: :plan  # item pode ser plan, package ou additional_service
    due_date { Date.today.next_month }
    value { 100.0 }
  end
end
