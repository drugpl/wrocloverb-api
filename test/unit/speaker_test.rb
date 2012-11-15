require 'test_helper'

class SpeakerTest < ActiveSupport::TestCase
  setup do
    @speaker = Speaker.new
    @speaker.name = "Nick Sutterer"
    @speaker.bio  = "Serial drinker"
    @speaker.website_url = "http://nicksda.apotomo.de"
    @speaker.slots << Slot.new
  end

  test "should have valid setup" do
    assert @speaker.valid?
  end

  test "should have name" do
    assert @speaker.name
  end

  test "should validate name" do
    @speaker.name = nil
    refute @speaker.valid?
  end

  test "shoudl have bio" do
    assert @speaker.bio
  end

  test "should validate bio" do
    @speaker.bio = nil
    refute @speaker.valid?
  end

  test "should have website url" do
    assert @speaker.website_url
  end

  test "should have slots assigned" do
    assert_kind_of Slot, @speaker.slots.first
  end
end
