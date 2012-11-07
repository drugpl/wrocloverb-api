class ApiController < ActionController::API
  include ActionController::MimeResponds
  include Roar::Rails::ControllerAdditions

  respond_to :json

  rescue_from 'ActiveRecord::RecordNotFound' do |exception|
    render json: {message: 'Not found'}, status: 404
  end
end
