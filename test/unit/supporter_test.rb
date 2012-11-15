require 'test_helper'

class SupporterTest < ActiveSupport::TestCase
  setup do
    @supporter = Supporter.new
    @supporter.name = "Engine Yard"
    @supporter.logo_url = "http://engineyard.com/images/logo.png"
    @supporter.website_url = "http://engineyard.com"
  end

  test "should have valid setup" do
    assert @supporter.valid?
  end

  test "should have name" do
    assert @supporter.name
  end

  test "should validate name" do
    @supporter.name = nil
    refute @supporter.valid?
  end

  test "should have logo url" do
    assert @supporter.logo_url
  end

  test "should have website url" do
    assert @supporter.website_url
  end
end
