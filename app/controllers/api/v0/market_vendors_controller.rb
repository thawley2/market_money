class Api::V0::MarketVendorsController < ApplicationController
  before_action :store_market_vendor_id, only: [:destroy]

  def create
    MarketVendor.create!(market_vendor_params)
    render json: {message: 'Successfully added vendor to market'}, status: :created
  end

  def destroy
    begin
      MarketVendor.find_by!(market_vendor_params).destroy
    rescue ActiveRecord::RecordNotFound
      render json: ErrorSerializer.serialize(
        "No MarketVendor with market_id=#{@market_id} AND vendor_id=#{@vendor_id} exists"), 
        status: :not_found
    end
  end

  private
  def market_vendor_params
    params.require(:market_vendor).permit(:vendor_id, :market_id)
  end

  def store_market_vendor_id
    @market_id = params[:market_vendor][:market_id]
    @vendor_id = params[:market_vendor][:vendor_id]
  end
end