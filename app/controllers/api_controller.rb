class ApiController < ActionController::API
  include ActionController::MimeResponds
  include Roar::Rails::ControllerAdditions
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  respond_to :json

  rescue_from 'ActiveRecord::RecordNotFound' do |exception|
    render json: {message: 'Not found'}, status: 404
  end

  protected

  def require_token
    authenticate_or_request_with_http_basic { |token, password| ApiToken.find_by_token(token) }
  end    
end
