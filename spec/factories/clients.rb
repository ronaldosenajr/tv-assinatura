FactoryBot.define do
  factory :client do
    name { "John Doe" }
    age { 25 }

    trait :adult_jane do
      name { "Jane Smith" }
      age { 30 }
    end

    trait :underage do
      name { "John Smith" }
      age { 17 }
    end
  end
end
