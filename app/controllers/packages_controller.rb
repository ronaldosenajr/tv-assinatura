class PackagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  allow_unauthenticated_access
  before_action :set_package, only: [ :show, :update, :destroy ]

  def index
    packages = Package.includes(:plan, :additional_services).all
    render json: packages
  end

  def show
    render json: @package
  end

  def create
    @package = Package.new(package_params)
    if @package.save
      render json: @package, status: :created
    else
      render json: { errors: @package.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @package.update(package_params)
      render json: @package
    else
      render json: { errors: @package.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @package.destroy
    head :no_content
  end

  private
  def set_package
    @package = Package.find_by(id: params[:id])
    if @package.nil?
      render json: { error: "Package not found" }, status: :not_found
    end
  end

  def package_params
    params.require(:package).permit(:name, :value, :plan_id, additional_service_ids: [])
  end
end
