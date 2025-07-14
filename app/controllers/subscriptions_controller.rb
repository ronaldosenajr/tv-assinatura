class SubscriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  allow_unauthenticated_access

  before_action :set_subscription, only: [ :show, :update, :destroy, :billing_totals, :booklet, :booklet_pdf ]

  def index
    render json: Subscription.includes(:client, :plan, :package, :additional_services).all
  end

  def show
    render json: @subscription
  end

  def create
    @subscription = Subscription.new(subscription_params)
    if @subscription.save
      @subscription.create_booklet!
      render json: @subscription, status: :created
    else
      render json: { errors: @subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @subscription.update(subscription_params)
      render json: @subscription, status: :ok
    else
      render json: { errors: @subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @subscription.destroy
    render json: @subscription, status: :ok
  end

  def billing_totals
    booklet = @subscription.booklet

    if booklet.nil?
      render json: { error: "Booklet not found" }, status: :not_found
      return
    end

    totals = booklet.monthly_totals_array

    render json: {
      subscription_id: @subscription.id,
      totals: totals
    }
  end

  def booklet
    booklet = @subscription.booklet

    if booklet
      render json: booklet
    else
      render json: { error: "Booklet not found" }, status: :not_found
    end
  end

  def booklet_pdf
    booklet = @subscription.booklet

    if booklet.nil?
      render json: { error: "Booklet not found" }, status: :not_found
      return
    end

    pdf = Prawn::Document.new
    client_name = @subscription.client.name
    pdf.text "Carnê do Cliente ##{client_name}"
    pdf.move_down 10

    booklet.invoices.order(:due_date).each_with_index do |invoice, index|
      pdf.text "Fatura #{index + 1} - Vencimento: #{invoice.due_date} - Total: R$ #{'%.2f' % invoice.total_value}"
      invoice.bills_for_invoice.each do |bill|
        item_name = case bill.item_type
        when "Plan"
                      Plan.find_by(id: bill.item_id)&.name || "Plano desconhecido"
        when "AdditionalService"
                      AdditionalService.find_by(id: bill.item_id)&.name || "Serviço desconhecido"
        else
                      "Item desconhecido"
        end
        pdf.text "  • #{bill.item_type}: #{item_name} - R$ #{'%.2f' % bill.value}"
      end
      pdf.move_down 10
    end

    send_data pdf.render,
              filename: "carne_cliente_#{@subscription.client_id}.pdf",
              type: "application/pdf",
              disposition: "inline"
  end

  private
  def set_subscription
    @subscription = Subscription.find_by(id: params[:id])
    if @subscription.nil?
      render json: { error: "Subscription not found" }, status: :not_found
    end
  end

  def subscription_params
    params.require(:subscription).permit(:client_id, :plan_id, :package_id, additional_service_ids: [])
  end
end
