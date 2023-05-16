class Api::V0::MarketsController < ApplicationController
  
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    begin
      render json: MarketSerializer.new(Market.find(params[:id]))
    rescue ActiveRecord::RecordNotFound => exception
      render json: ErrorSerializer.serialize(exception), status: 404
    end
  end
end