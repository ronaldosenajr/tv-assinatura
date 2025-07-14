require 'rails_helper'

RSpec.describe Client, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:age) }
  it { should validate_numericality_of(:age).is_greater_than(17) }

it "has an invalid underage trait" do
  client = build(:client, :underage)
  expect(client).to be_invalid
  client.valid? # força a validação para popular client.errors
  expect(client.errors[:age]).to include("must be greater than 17")
end
end
