class PlansController < ApplicationController
  skip_before_action :verify_authenticity_token
  allow_unauthenticated_access
  before_action :set_plan, only: [ :show, :update, :destroy ]
  def index
    @plans = Plan.all
    render json: @plans
  end

  def show
    render json: @plan
  end

  def create
    @plan = Plan.new(plan_params)
    if @plan.save
      render json: @plan, status: :created
    else
      render json: { errors: @plan.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @plan.update(plan_params)
      render json: @plan, status: :ok
    else
      render json: { errors: @plan.errors.full_messages }, status: :unprocessable_entity
    end
  end

   def destroy
     @plan.destroy
     render json: @plan, status: :ok
   end

  private
  def set_plan
    @plan = Plan.find_by(id: params[:id])
    if @plan.nil?
      render json: { error: "Plan not found" }, status: :not_found
    end
  end

  def plan_params
    params.require(:plan).permit(:name, :value)
  end
end
