class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :no_record
end
