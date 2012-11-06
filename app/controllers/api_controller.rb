class ApiController < ActionController::API
  include ActionController::MimeResponds
  include Roar::Rails::ControllerAdditions

  respond_to :json
end
