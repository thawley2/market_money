class ErrorSerializer
  def initialize(id)
    @id = id
  end

  def serialize
    { 
      errors: [
        {
          detail: "Couldn't find Market with 'id'=#{@id}"
          }
          ]
        }
  end
end