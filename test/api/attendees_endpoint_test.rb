require 'test_helper'
require 'active_support/core_ext/hash/except'

class AttendeesEndpointTest < ApiTestCase
  setup do
    @api_token = api_tokens(:one)
    @attendee = attendees(:lefty)
    @client = TestClient.new(
      headers: {
        'Accept' => MEDIA_TYPE,
        'Content-Type' => MEDIA_TYPE
      }
    )
  end

  def valid_attendee_data
    { name: 'Pawel Lewinsky' }.stringify_keys
  end

  test "should list attendees" do
    response = @client.get '/api/attendees'
    assert_equal 200, response.status
    assert_equal 1, response.body.size

    attendee = response.body.first
    assert_equal @attendee.name, attendee['name']
  end

  test "should create attendee given valid params" do
    response = @client.post '/api/attendees', valid_attendee_data.to_json, authentication_header
    assert_equal 201, response.status
    assert_match %r[/api/attendees/\d], response.headers['Location']

    attendee = response.body
    assert_equal valid_attendee_data['name'], attendee['name']
  end

  test "should require api key to create" do
    response = @client.post '/api/attendees/', valid_attendee_data.to_json
    assert_equal 401, response.status
  end
  test "should not create attendee given invalid params" do
    invalid_attendee_data = valid_attendee_data.except('name')
    response = @client.post '/api/attendees', invalid_attendee_data.to_json, authentication_header
    assert_equal 422, response.status

    errors = response.body
    assert_equal 1, errors['errors'].size
    assert errors['errors']['name']
  end

  test "should present given attendee" do
    response = @client.get "/api/attendees/#{@attendee.id}"
    assert_equal 200, response.status

    attendee = response.body
    assert_equal @attendee.name, attendee['name']
  end

  test "should return not found for invalid attendee" do
    response = @client.get "/api/attendees/invalid"
    assert_equal 404, response.status

    error = response.body
    assert_equal "Not found", error['message']
  end

  test "should update attendee given valid params" do
    response = @client.put "/api/attendees/#{@attendee.id}", {name: 'Jan Kowalski'}.to_json, authentication_header
    assert_equal 204, response.status

    assert_empty response.body
    response = @client.get "/api/attendees/#{@attendee.id}"
    assert_equal 'Jan Kowalski', response.body['name']
  end

  test "should require api key to update" do
    response = @client.put "/api/attendees/#{@attendee.id}", {name: 'Jan Kowalski'}.to_json
    assert_equal 401, response.status
  end

  test "should update attendee with PATCH when available in Rails" do
    begin
      id = @attendee.id
      response = @client.patch "/api/attendees/#{id}", {name: 'Jan Kowalski'}.to_json, authentication_header
      assert_equal 204, response.status

      assert_empty response.body
      raise "PATCH should be preferred"
    rescue => error
      raise unless error.message =~ /No route matches \[PATCH\]/
    end
  end

  test "should not update attendee given invalid data" do
    response = @client.put "/api/attendees/#{@attendee.id}", {name: nil}.to_json, authentication_header
    assert_equal 422, response.status

    errors = response.body
    assert_equal 1, errors['errors'].size
    assert errors['errors']['name']
  end

  test "should require api key to destroy" do
    response = @client.delete "/api/attendees/#{@attendee.id}"
    assert_equal 401, response.status
  end

  test "should destroy attendee" do
    response = @client.delete "/api/attendees/#{@attendee.id}", nil, authentication_header
    assert_equal 204, response.status
    assert_empty response.body

    response = @client.get "/api/attendees/#{@attendee.id}"
    assert_equal 404, response.status
  end


end
