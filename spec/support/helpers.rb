require_relative 'helpers/session_helper'

RSpec.configure do |config|
  config.include SessionHelper, :type => :feature
end
