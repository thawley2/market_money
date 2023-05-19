class SearchService
  def initialize(params)
    @params = params
  end

  def determine_search
    # require 'pry'; binding.pry
    if state_city_name
      Market.search_state_city_name(@params)
    elsif state_city
      Market.search_state_city(@params)
    elsif state_name
      Market.search_state_name(@params)
    elsif state
      Market.search_state(@params)
    elsif name_no_city
      Market.search_name(@params)
    else
      false
    end

    def valid_search
      if state_city_name
        true
      elsif state_city
        true
      elsif state_name
        true
      elsif state
        true
      elsif name_no_city
        true
      else
        false
      end 
    end

    private
    
    def state_city_name
      if @params.key?(:state) && @params.key?(:city) && @params.key?(:name)
        return true
      end
    end

    def state_city
      if @params.key?(:state) && @params.key?(:city)
        return true
      end
    end

    def state_name
      if @params.key?(:state) && @params.key?(:name)
        return true
      end
    end

    def state
      if @params.key?(:state)
        return true
      end
    end

    def name_no_city
      if @params.key?(:name) && !@params.key?(:city)
        return true
      end
    end
  end
end