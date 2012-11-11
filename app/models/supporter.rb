class Supporter < ActiveRecord::Base
  attr_accessible :logo_url, :name, :website_url

  validates :name, presence: true
end
