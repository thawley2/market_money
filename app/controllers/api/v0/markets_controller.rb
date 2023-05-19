class Api::V0::MarketsController < ApplicationController
  
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
      render json: MarketSerializer.new(Market.find(params[:id]))
  end

  def atms
    market = Market.find(params[:market_id])
    render json: AtmSerializer.new(AtmFacade.new(market).atms)
  end

  def search
    if params.key?(:state) && params.key?(:city) && params.key?(:name)
      serialize(Market.search_state_city_name(params))
    elsif params.key?(:state) && params.key?(:city)
      serialize(Market.search_state_city(params))
    elsif params.key?(:state) && params.key?(:name)
      serialize(Market.search_state_name(params))
    elsif params.key?(:state)
      serialize(Market.search_state(params))
    elsif params.key?(:name) && !params.key?(:city)
      serialize(Market.search_name(params))
    else
      render json: ErrorSerializer.missing_search_parameters, status: 422
    end
  end

  private
    def serialize(objects)
      render json: MarketSerializer.new(objects)
    end
end