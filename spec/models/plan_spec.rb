require 'rails_helper'

RSpec.describe Plan, type: :model do
  it { should have_many(:packages) }
  it { should have_many(:subscriptions).dependent(:nullify) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:value) }
  it { should validate_numericality_of(:value) }

  context 'validations' do
    it 'is invalid without name' do
      plan = build(:plan, name: nil)
      expect(plan).not_to be_valid
      expect(plan.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without value' do
      plan = build(:plan, value: nil)
      expect(plan).not_to be_valid
      expect(plan.errors[:value]).to include("can't be blank")
    end

    it 'is invalid with non-numeric value' do
      plan = build(:plan, value: "abc")
      expect(plan).not_to be_valid
      expect(plan.errors[:value]).to include("is not a number")
    end
  end
end
