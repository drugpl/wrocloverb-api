class Organizer < ActiveRecord::Base
  attr_protected

  validates :name, presence: true
end
