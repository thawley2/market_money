class ErrorSerializer
  def self.serialize(error)
    { 
      errors: [
        {
          detail: error
          }
          ]
        }
  end

  def self.serialize_uniq(mk_id, vn_id)
    message = "Validation failed: Market vendor association between market with market_id=#{mk_id} and vendor_id=#{vn_id} already exists"
    serialize(message)
  end

  def self.missing_search_parameters
    message = "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."
    serialize(message)
  end
end