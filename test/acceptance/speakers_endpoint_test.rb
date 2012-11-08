require 'test_helper'
require 'active_support/core_ext/hash/except'

class SpeakersEndpointTest < Bbq::TestCase
  MEDIA_TYPE = 'application/json'

  setup do
    @api_token = api_tokens(:one)
    @apotonick = speakers(:apotonick)
    @client = TestClient.new(
      headers: {
        'Accept' => MEDIA_TYPE,
        'Content-Type' => MEDIA_TYPE
      }
    )
  end

  def valid_speaker_data
    { name: 'Michal Lomnicki', bio: 'The Polish Guy.', website_url: 'mlomnicki.com' }.stringify_keys
  end

  def authentication_header
    { 'Authorization' => encode_token(@api_token.token) }
  end

  def encode_token(token)
    ActionController::HttpAuthentication::Basic.encode_credentials(token, nil)
  end

  test "should list speakers" do
    response = @client.get '/api/speakers'
    assert_equal 200, response.status
    assert_equal 1, response.body.size

    speaker = response.body.first
    assert_equal @apotonick.name, speaker['name']
    assert_equal @apotonick.bio, speaker['bio']
    assert_equal @apotonick.website_url, speaker['website_url']
  end

  test "should create speaker given valid params" do
    response = @client.post '/api/speakers', valid_speaker_data.to_json, authentication_header
    assert_equal 201, response.status
    assert_match %r[/api/speakers/\d], response.headers['Location']

    speaker = response.body
    assert_equal valid_speaker_data['name'], speaker['name']
    assert_equal valid_speaker_data['bio'], speaker['bio']
    assert_equal valid_speaker_data['website_url'], speaker['website_url']
  end

  test "should require api key to create" do
    response = @client.post '/api/speakers/', valid_speaker_data.to_json
    assert_equal 401, response.status
  end

  test "should not create speaker given invalid params" do
    invalid_speaker_data = valid_speaker_data.except('name')
    response = @client.post '/api/speakers', invalid_speaker_data.to_json, authentication_header
    assert_equal 422, response.status

    errors = response.body
    assert_equal 1, errors['errors'].size
    assert errors['errors']['name']
  end

  test "should present given speaker" do
    response = @client.get "/api/speakers/#{@apotonick.id}"
    assert_equal 200, response.status

    speaker = response.body
    assert_equal @apotonick.name, speaker['name']
    assert_equal @apotonick.bio, speaker['bio']
    assert_equal @apotonick.website_url, speaker['website_url']
  end

  test "should return not found for invalid speaker" do
    response = @client.get "/api/speakers/invalid"
    assert_equal 404, response.status

    error = response.body
    assert_equal "Not found", error['message']
  end

  test "should update speaker given valid params" do
    response = @client.put "/api/speakers/#{@apotonick.id}", {name: 'Apotonick'}.to_json, authentication_header
    assert_equal 204, response.status

    assert_empty response.body
    response = @client.get "/api/speakers/#{@apotonick.id}"
    assert_equal 'Apotonick', response.body['name']
  end

  test "should require api key to update" do
    response = @client.put "/api/speakers/#{@apotonick.id}", {name: 'Apotonick'}.to_json
    assert_equal 401, response.status
  end

  test "should update speaker with PATCH when available in Rails" do
    begin
      id = @apotonick.id
      response = @client.patch "/api/speakers/#{id}", {name: 'Apotonick'}.to_json, authentication_header
      assert_equal 204, response.status

      assert_empty response.body
      raise "PATCH should be preferred"
    rescue => error
      raise unless error.message =~ /No route matches \[PATCH\]/
    end
  end

  test "should not update speaker given invalid data" do
    response = @client.put "/api/speakers/#{@apotonick.id}", {name: nil}.to_json, authentication_header
    assert_equal 422, response.status

    errors = response.body
    assert_equal 1, errors['errors'].size
    assert errors['errors']['name']
  end

  test "should require api key to destroy" do
    response = @client.delete "/api/speakers/#{@apotonick.id}"
    assert_equal 401, response.status
  end

  test "should destroy speaker" do
    response = @client.delete "/api/speakers/#{@apotonick.id}", nil, authentication_header
    assert_equal 204, response.status
    assert_empty response.body

    response = @client.get "/api/speakers/#{@apotonick.id}"
    assert_equal 404, response.status
  end
end
