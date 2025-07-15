FactoryBot.define do
  factory :booklet do
    association :subscription

    # como o Booklet depende de invoices do subscription, você pode criar invoices no after(:create)
    after(:create) do |booklet|
      # Cria 3 invoices para o subscription
      create_list(:invoice, 3, subscription: booklet.subscription, total_value: 100.0)
    end
  end
end
