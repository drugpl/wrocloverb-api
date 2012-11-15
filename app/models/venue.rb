class Venue < ActiveRecord::Base
  attr_protected

  serialize :location, LocationSerializer.new

  has_many :slots

  validates :name, presence: true
  validates :address, presence: true
end
