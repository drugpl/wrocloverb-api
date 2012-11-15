require 'test_helper'

class SlotTest < ActiveSupport::TestCase
  setup do
    @slot = Slot.new
    @slot.name = "Testing fishbowl"
    @slot.ending_at   = 1.hour.from_now
    @slot.starting_at = 1.hour.ago
    @slot.venue = Venue.new
    @slot.speakers << Speaker.new
  end

  test "should have valid setup" do
    assert @slot.valid?
  end

  test "should have name" do
    assert @slot.name
  end

  test "should validate name" do
    @slot.name = nil
    refute @slot.valid?
  end

  test "should have starting time and date" do
    assert_respond_to @slot.starting_at, :iso8601
  end

  test "should have ending time and date" do
    assert_respond_to @slot.ending_at, :iso8601
  end

  test "should have venue" do
    assert_kind_of Venue, @slot.venue
  end

  test "should validate venue" do
    @slot.venue = nil
    refute @slot.valid?
  end

  test "should have speakers" do
    assert_kind_of Speaker, @slot.speakers.first
  end
end
