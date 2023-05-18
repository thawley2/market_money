class Api::V0::MarketVendorsController < ApplicationController
  def create
    MarketVendor.create!(market_vendor_params)
    render json: {message: 'Successfully added vendor to market'}, status: :created
  end

  def destroy
    begin
      MarketVendor.find_by!(market_vendor_params).destroy
    rescue ActiveRecord::RecordNotFound
      render json: {errors: [{detail: "No MarketVendor with market_id=#{params[:mv][:market_id]} AND vendor_id=#{params[:mv][:vendor_id]} exists"}]}, status: :not_found
    end
  end

  private
  def market_vendor_params
    params.require(:mv).permit(:vendor_id, :market_id)
  end
end