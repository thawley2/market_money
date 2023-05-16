class Api::V0::VendorsController < ApplicationController
  
  def index
    begin
      market = Market.find(params[:market_id])
      render json: VendorSerializer.new(market.vendors)
    rescue ActiveRecord::RecordNotFound => exception
      error_handling(exception)
    end
  end

  def show
    begin
      vendor = Vendor.find(params[:id])
      render json: VendorSerializer.new(Vendor.find(params[:id]))
    rescue ActiveRecord::RecordNotFound => exception
      error_handling(exception)
    end
  end

  private
    def error_handling(error)
      render json: ErrorSerializer.serialize(error), status: 404
    end
end