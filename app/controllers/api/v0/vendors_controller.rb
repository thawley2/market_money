class Api::V0::VendorsController < ApplicationController
  before_action :find_market
  
def index
    render json: VendorSerializer.new(@market.vendors)
  end

  private
    def find_market
      @market = Market.find(params[:market_id])
    end

    def no_record
      render json: ErrorSerializer.new(params[:market_id]).serialize, status: 404
    end
end