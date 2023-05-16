class Api::V0::MarketsController < ApplicationController
  
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render json: MarketSerializer.new(Market.find(params[:id]))
  end

  private
  def no_record
    render json: ErrorSerializer.new(params[:id]).serialize, status: 404
  end
end