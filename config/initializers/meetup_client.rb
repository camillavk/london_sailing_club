MeetupClient.configure do |config|
  config.api_key = Rails.env.development? ? Rails.application.secrets.meetup_api_key : ENV["meetup_api_key"]
end
