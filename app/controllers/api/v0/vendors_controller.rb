class Api::V0::VendorsController < ApplicationController
  
  def index
      market = Market.find(params[:market_id])
      render json: VendorSerializer.new(market.vendors)
  end

  def show
      vendor = Vendor.find(params[:id])
      render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  def create
    vendor = Vendor.new(vendor_params)
    if vendor.save
      render json: VendorSerializer.new(vendor), status: 201
    else
      render json: ErrorSerializer.new_serialize(vendor.errors.full_messages), status: 400
    end
  end

  private
    def vendor_params
      params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
    end
end