# spec/models/subscription_spec.rb
require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:client) { create(:client) }
  let(:plan) { create(:plan, value: 100.0) }
  let(:package) { create(:package, plan: plan, value: 200.0, additional_services: [ create(:additional_service, value: 10.0) ]) }
  let(:service1) { create(:additional_service, value: 30.0) }
  let(:service2) { create(:additional_service, value: 40.0) }

  subject { build(:subscription, client: client) }

  describe 'validations' do
    it "is invalid with both plan and package" do
      subject.plan = plan
      subject.package = package
      expect(subject).not_to be_valid
      expect(subject.errors[:base]).to include("Assinatura não pode ter plano e pacote ao mesmo tempo")
    end

    it "is invalid without plan or package" do
      subject.plan = nil
      subject.package = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:base]).to include("Assinatura precisa ter plano ou pacote")
    end

    it "validates no duplicate additional services" do
      subject.plan = plan
      service = create(:additional_service)
      subject.additional_services << service
      subject.additional_services << service
      expect(subject).not_to be_valid
      expect(subject.errors[:base]).to include("Assinatura não pode ter serviços adicionais duplicados")
    end

    it "validates no service conflict with package" do
      subject.package = package
      # adiciona um serviço que já está no pacote
      conflicting_service = package.additional_services.first
      subject.additional_services << conflicting_service
      expect(subject).not_to be_valid
      expect(subject.errors[:base]).to include(/Assinatura não pode ter serviços adicionais que estejam no pacote/)
    end

    context "client subscription conflict" do
      before do
        create(:subscription, client: client, plan: plan)
      end

      it "does not allow client to have plan and package subscriptions simultaneously" do
        new_sub = build(:subscription, client: client, package: package)
        expect(new_sub).not_to be_valid
        expect(new_sub.errors[:base]).to include("Cliente já tem assinatura com plano. Não pode assinar pacote simultaneamente")
      end

      it "does not allow client to have package and plan subscriptions simultaneously" do
        # Cria a assinatura com pacote sem validar (para evitar erro)
        build(:subscription, client: client, package: package).save(validate: false)
        new_sub = build(:subscription, client: client, plan: plan)
        expect(new_sub).not_to be_valid
        expect(new_sub.errors[:base]).to include("Cliente já tem assinatura com pacote. Não pode assinar plano simultaneamente")
      end
    end
  end

  describe "callbacks" do
    it "generates billing and booklet after create" do
      additional_service = create(:additional_service, value: 20.0)
      subscription = create(:subscription, client: client, plan: plan, additional_services: [ additional_service ])


      expect(subscription.bills.count).to eq(12 * (1 + subscription.additional_services.count))
      expect(subscription.invoices.count).to eq(12)
      expect(subscription.booklet).to be_present

      subscription.invoices.each do |invoice|
        bills_for_month = subscription.bills.where(due_date: invoice.due_date)
        bills_total = bills_for_month.sum(&:value)

        expect(invoice.total_value).to eq(bills_total)

        # Verifica se as bills incluem o plano
        expect(bills_for_month.any? { |b| b.item == subscription.plan }).to be true

        # Verifica se as bills incluem os serviços adicionais
        subscription.additional_services.each do |service|
          expect(bills_for_month.any? { |b| b.item == service }).to be true
        end
      end
    end
  end

  describe "billing regeneration on update" do
    let!(:subscription) { create(:subscription, client: client, plan: plan, additional_services: [ service1 ]) }
    let(:plan2) { create(:plan, value: 150.0) }
    let(:package2) { create(:package, plan: plan2, value: 250.0, additional_services: [ create(:additional_service, value: 20.0) ]) }
    it "calls regenerate_billing! when plan changes" do
      subscription = create(:subscription, client: client, plan: plan)
      expect_any_instance_of(Subscription).to receive(:regenerate_billing!)
      subscription.update(plan: plan2)
    end

    it "calls regenerate_billing! when package changes" do
      client_without_subscription = create(:client) # novo cliente limpo
      subscription = create(:subscription, client: client_without_subscription, plan: nil, package: package)
      expect_any_instance_of(Subscription).to receive(:regenerate_billing!)
      subscription.update(package: package2)
    end

    it "calls regenerate_billing! when additional_services change" do
      client_without_subscription = create(:client) # novo cliente limpo
      subscription = create(:subscription, client: client_without_subscription, plan: plan, additional_services: [ service1 ])

      expect(subscription).to receive(:regenerate_billing!).at_least(:once)

      subscription.subscription_additional_services.create!(additional_service: service2)
    end

    it "does NOT call regenerate_billing! when unrelated attribute changes" do
      expect_any_instance_of(Subscription).not_to receive(:regenerate_billing!)
      subscription.update(client: client)
    end
  end
end
