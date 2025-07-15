FactoryBot.define do
  factory :invoice do
    association :subscription
    due_date { Date.today.next_month }
    total_value { 100.0 }
  end
end
