class Api::V0::Markets::SearchesController < ApplicationController

  def show
    # require 'pry'; binding.pry
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

