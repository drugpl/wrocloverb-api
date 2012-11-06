class Speaker < ActiveRecord::Base
  attr_protected

  validates :name, presence: true
  validates :bio, presence: true
end
