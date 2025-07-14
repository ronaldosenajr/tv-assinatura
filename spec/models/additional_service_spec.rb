require 'rails_helper'

RSpec.describe AdditionalService, type: :model do
  it { should have_many(:package_additional_services).dependent(:destroy) }
  it { should have_many(:subscription_additional_services).dependent(:destroy) }
  it { should have_many(:packages).through(:package_additional_services) }
  it { should have_many(:subscriptions).through(:subscription_additional_services) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:value) }
  it { should validate_numericality_of(:value) }

  context 'validations' do
    it 'is invalid without name' do
      additional_service = build(:additional_service, name: nil)
      expect(additional_service).not_to be_valid
      expect(additional_service.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without value' do
      additional_service = build(:additional_service, value: nil)
      expect(additional_service).not_to be_valid
      expect(additional_service.errors[:value]).to include("can't be blank")
    end

    it 'is invalid with non-numeric value' do
      additional_service = build(:additional_service, value: "not a number")
      expect(additional_service).not_to be_valid
      expect(additional_service.errors[:value]).to include("is not a number")
    end
  end
end
