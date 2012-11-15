require 'test_helper'

class AttendeeTest < ActiveSupport::TestCase
  setup do
    @attendee = Attendee.new
    @attendee.name = "Robert Pankowecki"
    @attendee.website_url = "http://robert.pankowecki.pl"
  end

  test "should have valid setup" do
    assert @attendee.valid?
  end

  test "should have name" do
    assert @attendee.name
  end

  test "should validate name" do
    @attendee.name = nil
    refute @attendee.valid?
  end

  test "should have website url" do
    assert @attendee.website_url
  end
end
