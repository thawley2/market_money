class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :error_handling

  private
    def error_handling(error)
      render json: ErrorSerializer.serialize(error), status: 404
    end
end
