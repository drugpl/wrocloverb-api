require 'test_helper'
require 'active_support/core_ext/hash/except'

class VenuesEndpointTest < ApiTestCase
  setup do
    @api_token = api_tokens(:one)
    @venue = venues(:univeristy)
    @client = TestClient.new(
      headers: {
        'Accept' => MEDIA_TYPE,
        'Content-Type' => MEDIA_TYPE
      }
    )
  end

  def valid_venue_data
    { name: 'Instytut Informatyki Uniwersytetu Wroclawskiego', address: 'Joliot-Curie 15' }.stringify_keys
  end

  test "should list venues" do
    response = @client.get '/api/venues'
    assert_equal 200, response.status
    assert_equal 3, response.body.size

    venue = response.body.first
    assert_equal @venue.name, venue['name']
    assert_equal @venue.address, venue['address']
  end

  test "should create venue given valid params" do
    response = @client.post '/api/venues', valid_venue_data.to_json, authentication_header
    assert_equal 201, response.status
    assert_match %r[/api/venues/\d], response.headers['Location']

    venue = response.body
    assert_equal valid_venue_data['name'], venue['name']
  end

  test "should require api key to create" do
    response = @client.post '/api/venues/', valid_venue_data.to_json
    assert_equal 401, response.status
  end
  test "should not create venue given invalid params" do
    invalid_venue_data = valid_venue_data.except('name')
    response = @client.post '/api/venues', invalid_venue_data.to_json, authentication_header
    assert_equal 422, response.status

    errors = response.body
    assert_equal 1, errors['errors'].size
    assert errors['errors']['name']
  end

  test "should present given venue" do
    response = @client.get "/api/venues/#{@venue.id}"
    assert_equal 200, response.status

    venue = response.body
    assert_equal @venue.name, venue['name']
    assert_equal @venue.address, venue['address']
  end

  test "should return not found for invalid venue" do
    response = @client.get "/api/venues/invalid"
    assert_equal 404, response.status

    error = response.body
    assert_equal "Not found", error['message']
  end

  test "should update venue given valid params" do
    response = @client.put "/api/venues/#{@venue.id}", {name: 'starbucks'}.to_json, authentication_header
    assert_equal 204, response.status

    assert_empty response.body
    response = @client.get "/api/venues/#{@venue.id}"
    assert_equal 'starbucks', response.body['name']
  end

  test "should require api key to update" do
    response = @client.put "/api/venues/#{@venue.id}", {name: 'starbucks'}.to_json
    assert_equal 401, response.status
  end

  test "should update venue with PATCH when available in Rails" do
    begin
      id = @venue.id
      response = @client.patch "/api/venues/#{id}", {name: 'starbucks'}.to_json, authentication_header
      assert_equal 204, response.status

      assert_empty response.body
      raise "PATCH should be preferred"
    rescue => error
      raise unless error.message =~ /No route matches \[PATCH\]/
    end
  end

  test "should not update venue given invalid data" do
    response = @client.put "/api/venues/#{@venue.id}", {name: nil}.to_json, authentication_header
    assert_equal 422, response.status

    errors = response.body
    assert_equal 1, errors['errors'].size
    assert errors['errors']['name']
  end

  test "should require api key to destroy" do
    response = @client.delete "/api/venues/#{@venue.id}"
    assert_equal 401, response.status
  end

  test "should destroy venue" do
    response = @client.delete "/api/venues/#{@venue.id}", nil, authentication_header
    assert_equal 204, response.status
    assert_empty response.body

    response = @client.get "/api/venues/#{@venue.id}"
    assert_equal 404, response.status
  end


end
