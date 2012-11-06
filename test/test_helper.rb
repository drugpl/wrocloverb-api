ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'bbq/test_unit'

class ActiveSupport::TestCase
  fixtures :all
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
