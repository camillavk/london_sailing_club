class GocardlessController < ApplicationController
  before_action :load_gocardless_client
  before_action :load_redirect_flow

  def choice
    session[:redirect_flow] = @redirect_flow.id
    redirect_to @redirect_flow.redirect_url
  end

  def complete
    redirect_flow_id = session[:redirect_flow]
    @gocardless_client.redirect_flows.complete(
      "#{redirect_flow_id}", # The redirect flow ID from above.
      params: { session_token: "#{current_user.id}" }
    )
  end

  private

  def load_gocardless_client
    @gocardless_client ||= GoCardlessPro::Client.new(
      access_token: Rails.application.secrets.gocardless_token,
      environment: :sandbox
    )
  end

  def load_redirect_flow
    @redirect_flow = @gocardless_client.redirect_flows.create(
      params: {
        description: 'London Sailing Club Membership', # This will be shown on the payment pages
        session_token: "#{current_user.id}", # Not the access token
        success_redirect_url: 'http://localhost:3000/gocardless/complete', # Success page
        prefilled_customer: { # Optionally, prefill customer details on the payment page
          email: current_user.email
        }
      }
    )
  end
end
