require 'test_helper'

class SupporterTest < ActiveSupport::TestCase
  def setup
    @supporter = supporters(:engineyard)
  end

  test "should have valid fixture" do
    assert @supporter.valid?
  end

  test "should have name" do
    assert @supporter.name
  end

  test "should validate name" do
    @supporter.name = nil
    refute @supporter.valid?
  end
end
