class AdditionalServicesController < ApplicationController
  skip_before_action :verify_authenticity_token
  allow_unauthenticated_access
  before_action :set_additional_service, only: [ :show, :update, :destroy ]

  def index
    @additional_services = AdditionalService.all
    render json: @additional_services
  end

  def show
    render json: @additional_service
  end

  def create
    @additional_service = AdditionalService.new(additional_service_params)
    if @additional_service.save
      render json: @additional_service, status: :created
    else
      render json: { errors: @additional_service.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @additional_service.update(additional_service_params)
      render json: @additional_service, status: :ok
    else
      render json: { errors: @additional_service.errors.full_messages }, status: :unprocessable_entity
    end
  end

   def destroy
     @additional_service.destroy
     render json: @additional_service, status: :ok
   end

  private
  def set_additional_service
    @additional_service = AdditionalService.find_by(id: params[:id])
    if @additional_service.nil?
      render json: { error: "AdditionalService not found" }, status: :not_found
    end
  end

  def additional_service_params
    params.require(:additional_service).permit(:name, :value)
  end
end
