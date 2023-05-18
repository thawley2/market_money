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
end