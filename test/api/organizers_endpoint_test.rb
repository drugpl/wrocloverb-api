require 'test_helper'
require 'active_support/core_ext/hash/except'

class OrganizersEndpointTest < ApiTestCase
  setup do
    @api_token = api_tokens(:one)
    @organizer = organizers(:drug)
    @client = TestClient.new(
      headers: {
        'Accept' => MEDIA_TYPE,
        'Content-Type' => MEDIA_TYPE
      }
    )
  end

  def valid_organizer_data
    { name: 'DRUG' }.stringify_keys
  end

  test "should list organizers" do
    response = @client.get '/api/organizers'
    assert_equal 200, response.status
    assert_equal 1, response.body.size

    organizer = response.body.first
    assert_equal @organizer.name, organizer['name']
  end

  test "should create organizer given valid params" do
    response = @client.post '/api/organizers', valid_organizer_data.to_json, authentication_header
    assert_equal 201, response.status
    assert_match %r[/api/organizers/\d], response.headers['Location']

    organizer = response.body
    assert_equal valid_organizer_data['name'], organizer['name']
  end

  test "should require api key to create" do
    response = @client.post '/api/organizers/', valid_organizer_data.to_json
    assert_equal 401, response.status
  end
  test "should not create organizer given invalid params" do
    invalid_organizer_data = valid_organizer_data.except('name')
    response = @client.post '/api/organizers', invalid_organizer_data.to_json, authentication_header
    assert_equal 422, response.status

    errors = response.body
    assert_equal 1, errors['errors'].size
    assert errors['errors']['name']
  end

  test "should present given organizer" do
    response = @client.get "/api/organizers/#{@organizer.id}"
    assert_equal 200, response.status

    organizer = response.body
    assert_equal @organizer.name, organizer['name']
  end

  test "should return not found for invalid organizer" do
    response = @client.get "/api/organizers/invalid"
    assert_equal 404, response.status

    error = response.body
    assert_equal "Not found", error['message']
  end

  test "should update organizer given valid params" do
    response = @client.put "/api/organizers/#{@organizer.id}", {name: 'codeschool'}.to_json, authentication_header
    assert_equal 204, response.status

    assert_empty response.body
    response = @client.get "/api/organizers/#{@organizer.id}"
    assert_equal 'codeschool', response.body['name']
  end

  test "should require api key to update" do
    response = @client.put "/api/organizers/#{@organizer.id}", {name: 'codeschool'}.to_json
    assert_equal 401, response.status
  end

  test "should update organizer with PATCH when available in Rails" do
    begin
      id = @organizer.id
      response = @client.patch "/api/organizers/#{id}", {name: 'codeschool'}.to_json, authentication_header
      assert_equal 204, response.status

      assert_empty response.body
      raise "PATCH should be preferred"
    rescue => error
      raise unless error.message =~ /No route matches \[PATCH\]/
    end
  end

  test "should not update organizer given invalid data" do
    response = @client.put "/api/organizers/#{@organizer.id}", {name: nil}.to_json, authentication_header
    assert_equal 422, response.status

    errors = response.body
    assert_equal 1, errors['errors'].size
    assert errors['errors']['name']
  end

  test "should require api key to destroy" do
    response = @client.delete "/api/organizers/#{@organizer.id}"
    assert_equal 401, response.status
  end

  test "should destroy organizer" do
    response = @client.delete "/api/organizers/#{@organizer.id}", nil, authentication_header
    assert_equal 204, response.status
    assert_empty response.body

    response = @client.get "/api/organizers/#{@organizer.id}"
    assert_equal 404, response.status
  end
end