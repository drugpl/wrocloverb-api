require 'test_helper'
require 'active_support/core_ext/hash/except'

class SupportersEndpointTest < ApiTestCase
  setup do
    @api_token = api_tokens(:one)
    @supporters = supporters(:engineyard)
    @client = TestClient.new(
      headers: {
        'Accept' => MEDIA_TYPE,
        'Content-Type' => MEDIA_TYPE
      }
    )
  end

  def valid_supporter_data
    { name: 'Arkency', website_url: 'http://arkency.com/', logo_url: 'http://arkency.com/logo.jpg' }.stringify_keys
  end

  test "should list supporters" do
    response = @client.get '/api/supporters'
    assert_equal 200, response.status
    assert_equal 1, response.body.size

    supporter = response.body.first
    assert_equal @supporters.name, supporter['name']
    assert_equal @supporters.logo_url, supporter['logo_url']
    assert_equal @supporters.website_url, supporter['website_url']
  end

  test "should create supporter given valid params" do
    response = @client.post '/api/supporters', valid_supporter_data.to_json, authentication_header
    assert_equal 201, response.status
    assert_match %r[/api/supporters/\d], response.headers['Location']

    supporter = response.body
    assert_equal valid_supporter_data['name'], supporter['name']
    assert_equal valid_supporter_data['logo_url'], supporter['logo_url']
    assert_equal valid_supporter_data['website_url'], supporter['website_url']
  end

  test "should require api key to create" do
    response = @client.post '/api/supporters/', valid_supporter_data.to_json
    assert_equal 401, response.status
  end

  test "should not create supporter given invalid params" do
    invalid_supporter_data = valid_supporter_data.except('name')
    response = @client.post '/api/supporters', invalid_supporter_data.to_json, authentication_header
    assert_equal 422, response.status

    errors = response.body
    assert_equal 1, errors['errors'].size
    assert errors['errors']['name']
  end

  test "should present given supporter" do
    response = @client.get "/api/supporters/#{@supporters.id}"
    assert_equal 200, response.status

    supporter = response.body
    assert_equal @supporters.name, supporter['name']
    assert_equal @supporters.logo_url, supporter['logo_url']
    assert_equal @supporters.website_url, supporter['website_url']
  end

  test "should return not found for invalid supporter" do
    response = @client.get "/api/supporters/invalid"
    assert_equal 404, response.status

    error = response.body
    assert_equal "Not found", error['message']
  end

  test "should update supporter given valid params" do
    response = @client.put "/api/supporters/#{@supporters.id}", {name: 'gameboxed'}.to_json, authentication_header
    assert_equal 204, response.status

    assert_empty response.body
    response = @client.get "/api/supporters/#{@supporters.id}"
    assert_equal 'gameboxed', response.body['name']
  end

  test "should require api key to update" do
    response = @client.put "/api/supporters/#{@supporters.id}", {name: 'gameboxed'}.to_json
    assert_equal 401, response.status
  end

  test "should update supporter with PATCH when available in Rails" do
    begin
      id = @supporters.id
      response = @client.patch "/api/supporters/#{id}", {name: 'gameboxed'}.to_json, authentication_header
      assert_equal 204, response.status

      assert_empty response.body
      raise "PATCH should be preferred"
    rescue => error
      raise unless error.message =~ /No route matches \[PATCH\]/
    end
  end

  test "should not update supporter given invalid data" do
    response = @client.put "/api/supporters/#{@supporters.id}", {name: nil}.to_json, authentication_header
    assert_equal 422, response.status

    errors = response.body
    assert_equal 1, errors['errors'].size
    assert errors['errors']['name']
  end

  test "should require api key to destroy" do
    response = @client.delete "/api/supporters/#{@supporters.id}"
    assert_equal 401, response.status
  end

  test "should destroy supporter" do
    response = @client.delete "/api/supporters/#{@supporters.id}", nil, authentication_header
    assert_equal 204, response.status
    assert_empty response.body

    response = @client.get "/api/supporters/#{@supporters.id}"
    assert_equal 404, response.status
  end
end
