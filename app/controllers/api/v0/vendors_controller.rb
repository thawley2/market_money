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
    render json: VendorSerializer.new(Vendor.create!(vendor_params)), status: 201
  end

  private
    def vendor_params
      params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
    end
end