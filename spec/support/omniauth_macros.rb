module OmniauthMacros
  # rubocop:disable MethodLength
  def mock_auth_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:meetup] = {
      'provider' => 'meetup',
      'uid' => '123545',
      'user_info' => {
        'name' => 'mockuser'
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    }
  end
end

RSpec.configure do |config|
  config.include(OmniauthMacros)
end

OmniAuth.config.test_mode = true
