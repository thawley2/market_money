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
#another method that joins error by (,) for create
end