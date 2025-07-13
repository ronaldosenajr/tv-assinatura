class SubscriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  allow_unauthenticated_access

  before_action :set_subscription, only: [ :show, :update, :destroy ]

  def index
    render json: Subscription.includes(:client, :plan, :package, :additional_services).all
  end

  def show
    render json: @subscription
  end

  def create
    @subscription = Subscription.new(subscription_params)
    if @subscription.save
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
