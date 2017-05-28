if Rails.env.development? || Rails.env.test?
  Rails.configuration.stripe = {
    publishable_key: Rails.application.secrets.stripe_publishable,
    secret_key:      Rails.application.secrets.stripe_secret
  }
else
  Rails.configuration.stripe = {
    publishable_key: ENV['stripe_publishable'],
    secret_key:      ENV['stripe_secret']
  }
end

Stripe.api_key = Rails.configuration.stripe[:secret_key]
