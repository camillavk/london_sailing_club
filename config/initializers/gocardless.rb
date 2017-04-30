# if Rails.env.development?
#   GoCardless.account_details = {
#     app_id: Rails.application.secrets.gocardless_id,
#     app_secret: Rails.application.secrets.gocardless_secret,
#     token: Rails.application.secrets.gocardless_token,
#     merchant_id: Rails.application.secrets.gocardless_merchant,
#   }
# end
#
# if Rails.env.development?
#   GoCardless.environment = :sandbox
# end
gocardless = GoCardlessPro::Client.new(
  access_token: Rails.application.secrets.gocardless_token,
  environment: :sandbox
)
