class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :error_handling
  rescue_from ActiveRecord::RecordInvalid, with: :new_error_handling

  private
    def error_handling(error)
      render json: ErrorSerializer.serialize(error), status: 404
    end

    def new_error_handling(error)
      render json: ErrorSerializer.serialize(error), status: 400
    end
end
