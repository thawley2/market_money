class Api::V0::VendorsController < ApplicationController
  
  def show
      vendor = Vendor.find(params[:id])
      render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  def create
    render json: VendorSerializer.new(Vendor.create!(vendor_params)), status: :created
  end

  def destroy
    vendor = Vendor.find(params[:id])
    vendor.destroy
  end

  def update
    vendor = Vendor.find(params[:id])
    vendor.update!(vendor_params)
    render json: VendorSerializer.new(vendor)
  end

  private
    def vendor_params
      params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
    end
end