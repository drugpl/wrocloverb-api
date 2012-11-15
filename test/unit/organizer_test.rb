require 'test_helper'

class OrganizerTest < ActiveSupport::TestCase
  setup do
    @organizer = Organizer.new
    @organizer.name = "Jan Filipowski"
    @organizer.website_url = "http://agiler.net"
  end

  test "should have valid setup" do
    assert @organizer.valid?
  end

  test "should have name" do
    assert @organizer.name
  end

  test "should validate name" do
    @organizer.name = nil
    refute @organizer.valid?
  end

  test "should have website url" do
    assert @organizer.website_url
  end
end
