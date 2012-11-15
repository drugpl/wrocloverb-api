class ApiTestCase < Bbq::TestCase
  MEDIA_TYPE = 'application/json'

  def authentication_header
    { 'Authorization' => encode_token(@api_token.token) }
  end

  def encode_token(token)
    ActionController::HttpAuthentication::Basic.encode_credentials(token, nil)
  end
end
