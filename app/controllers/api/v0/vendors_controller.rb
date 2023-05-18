class Api::V0::VendorsController < ApplicationController
  before_action :find_vendor, only: [:show, :destroy, :update]
  def show
      render json: VendorSerializer.new(@vendor)
  end

  def create
    render json: VendorSerializer.new(Vendor.create!(vendor_params)), status: :created
  end

  def destroy
    @vendor.destroy
  end

  def update
    @vendor.update!(vendor_params)
    render json: VendorSerializer.new(@vendor)
  end

  private
    def vendor_params
      params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
    end

    def find_vendor
      @vendor = Vendor.find(params[:id])
    end
end