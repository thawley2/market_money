class Api::V0::Markets::SearchesController < ApplicationController

  def show
    if params.key?(:state) && params.key?(:city) && params.key?(:name)
      serialize(Market.search_state_city_name(params))
    elsif params.key?(:state) && params.key?(:city)
      serialize(Market.search_state_city(params))
    elsif params.key?(:state) && params.key?(:name)
      serialize(Market.search_state_name(params))
    elsif params.key?(:state)
      serialize(Market.search_state(params))
    elsif params.key?(:name)
      serialize(Market.search_name(params))
    else
      render json: ErrorSerializer("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
    end
  end

  private
    def serialize(objects)
      render json: MarketSerializer.new(objects)
    end
end

