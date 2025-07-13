class PackagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  allow_unauthenticated_access
  # before_action :set_package, only: [ :show, :update, :destroy ]

  def index
    packages = Package.includes(:plan, :additional_services).all
    render json: packages
  end

  private
  def set_package
    @package = Package.find_by(id: params[:id])
    if @package.nil?
      render json: { error: "Package not found" }, status: :not_found
    end
  end
end
