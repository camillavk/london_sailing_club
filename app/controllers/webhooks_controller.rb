require 'openssl'

class WebhooksController < ApplicationController
  protect_from_forgery except: :create
  include ActionController::Live

  def create
    # We recommend storing your webhook endpoint secret in an environment variable
    # for security, but you could include it as a string directly in your code
    secret = 

    # In a Rack app (e.g. Sinatra), access the POST body with
    # `request.body.tap(&:rewind).read`
    computed_signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'),
                                                 secret,
                                                 request.raw_post)

    # In a Rack app (e.g. Sinatra), the header is available as
    # `request.env['HTTP_WEBHOOK_SIGNATURE']`
    provided_signature = request.headers['Webhook-Signature']

    if Rack::Utils.secure_compare(provided_signature, computed_signature)
      render status: :ok
    else
      render status: 498
    end
  end
end
