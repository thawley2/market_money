class Api::V0::MarketsController < ApplicationController
  
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
      render json: MarketSerializer.new(Market.find(params[:id]))
  end

  def find_atms
    market = Market.find(params[:market_id])
    render json: AtmSerializer.new(AtmFacade.new(market).atms)
  end

  def search
    search = SearchService.new(params)
    require 'pry'; binding.pry
    if search.determine_search
      render json: MarketSerializer.new(search.determine_search)
    else
      render json: ErrorSerializer.missing_search_parameters, status: 422
    end
  end

  
end