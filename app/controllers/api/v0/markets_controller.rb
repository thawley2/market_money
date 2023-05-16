class Api::V0::MarketsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :no_record
  
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render json: MarketSerializer.new(Market.find(params[:id]))
  end

  private
    def no_record
      error_message = { 
        errors: [
          {
            detail: "Couldn't find Market with 'id'=#{params[:id]}"
            }
            ]
          }
      render json: error_message, status: 404
    end
end