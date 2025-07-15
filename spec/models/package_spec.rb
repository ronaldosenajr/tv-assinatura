require 'rails_helper'

RSpec.describe Package, type: :model do
  let(:plan) { create(:plan, value: 100.0) }
  let(:service1) { create(:additional_service, value: 10.0) }
  let(:service2) { create(:additional_service, value: 20.0) }

  subject { build(:package, plan: plan, additional_services: [ service1, service2 ], value: nil) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:plan) }
  it { should validate_numericality_of(:value).allow_nil }

  it "is invalid without any additional services" do
    subject.additional_services = []
    expect(subject.valid?).to be false
    expect(subject.errors[:additional_services]).to include("é preciso ter pelo menos um serviço adicional")
  end

  it "calculates value before validation if value is nil" do
    subject.value = nil
    subject.valid? # chama validação para disparar before_validation

    expect(subject.value).to eq(plan.value + service1.value + service2.value)
  end

  it "does not overwrite value if already set" do
    subject.value = 500.0
    subject.valid?

    expect(subject.value).to eq(500.0)
  end
end
