require 'test_helper'

class VenueTest < ActiveSupport::TestCase
  setup do
    @venue = Venue.new
    @venue.location = Location.new('50.0', '50.0')
    @venue.address = "ul. Joliot-Curie 15"
    @venue.name  = "II UWr"
  end

  test "should have valid setup" do
    assert @venue.valid?
  end

  test "should have name" do
    assert @venue.name
  end

  test "should validate name" do
    @venue.name = nil
    refute @venue.valid?
  end

  test "should have address" do
    assert @venue.address
  end

  test "should validate address" do
    @venue.address = nil
    refute @venue.valid?
  end

  test "should have location" do
    assert_kind_of Location, @venue.location
  end
end
