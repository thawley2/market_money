class Api::V0::MarketVendorsController < ApplicationController
  def create
    MarketVendor.create!(market_vendor_params)
    render json: {message: 'Successfully added vendor to market'}, status: :created
  end

  def destroy
    MarketVendor.find_by(market_vendor_params).destroy
  end

  private
  def market_vendor_params
    params.require(:mv).permit(:vendor_id, :market_id)
  end
end