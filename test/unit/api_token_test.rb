require 'test_helper'

class ApiTokenTest < ActiveSupport::TestCase
  setup do
    @api_token = api_tokens(:one)
  end

  test "should have token" do
    assert @api_token.token
  end

  test "should generate random token when created" do
    assert_not_equal ApiToken.create.token, ApiToken.create.token
  end
end
