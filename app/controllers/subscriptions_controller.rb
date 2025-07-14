class SubscriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  allow_unauthenticated_access

  before_action :set_subscription, only: [ :show, :update, :destroy, :billing_totals ]

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
