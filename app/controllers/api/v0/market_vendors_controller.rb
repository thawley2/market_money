class Api::V0::MarketVendorsController < ApplicationController
  def create
    MarketVendor.create!(market_vendor_params)
    render json: {message: 'Successfully added vendor to market'}, status: :created
  end

  private
  def market_vendor_params
    params.require(:mv).permit(:vendor_id, :market_id)
  end
end