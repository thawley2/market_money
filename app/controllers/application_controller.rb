class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  private
  def record_invalid(error)
    if error.to_s.include?('exist')
      not_found(error)
    elsif params.has_key?(:mv)
      not_unique
    else
      field_blank(error)
    end
  end

    def not_found(error)
      render json: ErrorSerializer.serialize(error), status: :not_found
    end

    def not_unique
      render json: ErrorSerializer.serialize_uniq(params[:mv][:market_id], params[:mv][:vendor_id]), status: 422
    end

    def field_blank(error)
      render json: ErrorSerializer.serialize(error), status: :bad_request
    end

end
