require 'test_helper'

class SpeakerTest < ActiveSupport::TestCase
  def setup
    @speaker = speakers(:apotonick)
  end

  test "should have valid fixture" do
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

  test "should have website_url" do
    assert @speaker.website_url
  end
end
