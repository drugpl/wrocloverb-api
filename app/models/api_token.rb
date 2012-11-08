require 'securerandom'

class ApiToken < ActiveRecord::Base
  attr_accessor :generator

  before_create :generate_token

  def initialize(*args)
    super(*args)
    self.generator ||= ->{ SecureRandom.hex }
  end

  protected

  def generate_token
    self.token = generator.call
  end
end
