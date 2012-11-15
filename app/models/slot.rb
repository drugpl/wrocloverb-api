class Slot < ActiveRecord::Base
  attr_protected

  belongs_to :venue
  has_and_belongs_to_many :speakers

  validates :starting_at, presence: true
  validates :ending_at, presence: true
  validates :venue, presence: true
  validates :name, presence: true
end
