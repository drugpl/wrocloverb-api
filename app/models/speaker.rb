class Speaker < ActiveRecord::Base
  attr_protected

  has_and_belongs_to_many :slots

  validates :name, presence: true
  validates :bio, presence: true
end
