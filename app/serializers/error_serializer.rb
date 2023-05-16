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
  
  def self.new_serialize(error)
    join_error = 'Validation failed: ' + error.join(', ')
    serialize(join_error)
  end
end