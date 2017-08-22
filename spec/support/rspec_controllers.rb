RSpec.configure do |config|
  config.render_views
  config.include Devise::Test::ControllerHelpers, type: :controller
end
