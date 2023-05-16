class Api::V0::VendorsController < ApplicationController
  before_action :find_market
  rescue_from ActiveRecord::RecordNotFound, with: :no_record
  
def index
    render json: VendorSerializer.new(@market.vendors)
  end

  private
    def find_market
      @market = Market.find(params[:market_id])
    end

    def no_record
      error_message = { 
        errors: [
          {
            detail: "Couldn't find Market with 'id'=#{params[:market_id]}"
            }
            ]
          }
      render json: error_message, status: 404
    end
end