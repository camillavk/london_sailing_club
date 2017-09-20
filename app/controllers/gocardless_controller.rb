class GocardlessController < ApplicationController
  before_action :load_gocardless_client

  def mandate_and_payment
    session.delete(:plan) if current_user.payment_date > 1.year.ago
    if current_user.mandate?
      begin
        collect_payment
        render 'complete_mandate'
      rescue => e
        flash[:error] = "Oops, are you sure you want to do that?"
        session.delete(:plan)
      end
    else
      create_mandate
      redirect_to @redirect_flow.redirect_url
    end
  end

  def complete_mandate
    @redirect_flow_id = session[:redirect_flow]
    complete_user_mandate
    update_user_with_payment_mandate
    collect_payment
  end

  def cancel
    @gocardless_client.payments.cancel(params[:payment_id])
    redirect_to request.referer
  end

  private

  def load_gocardless_client
    @gocardless_client ||= GoCardlessPro::Client.new(
      access_token: Rails.application.secrets.gocardless_token || ENV['gocardless_token'],
      environment: :sandbox
    )
  end

  def create_mandate
    success_url = Rails.env.development? ? 'http://localhost:3000/gocardless/complete_mandate' : 'https://london-sailing-club.herokuapp.com/gocardless/complete_mandate'
    @redirect_flow = @gocardless_client.redirect_flows.create(
      params: {
        description: 'London Sailing Club Membership',
        session_token: "#{current_user.id}",
        success_redirect_url: success_url, # Success page
        prefilled_customer: {
          email: current_user.email
        }
      }
    )
    session[:redirect_flow] = @redirect_flow.id
  end

  def complete_user_mandate
    @complete_mandate = @gocardless_client.redirect_flows.complete(
      "#{@redirect_flow_id}",
      params: { session_token: "#{current_user.id}" }
    )
  end

  def collect_payment
    if session[:plan] == 'free'
      return
    else
      subscription_payment
    end
  end

  def subscription_payment
    subscription = @gocardless_client.subscriptions.create(
      params: {
        amount: "#{session[:price_in_cents]}",
        currency: 'GBP',
        interval_unit: 'yearly',
        links: {
          mandate: "#{current_user.mandate}"
        },
        metadata: {
          plan: "#{session[:plan]}"
        }
      },
      headers: {
        'Idempotency-Key': "#{session[:plan]}_#{Date.today}_#{current_user.mandate}"
      }
    )

    current_user.update_attributes payment_date: Date.today,
                                   payment_amount: "#{Money.new(session[:price_in_cents], 'GBP')}",
                                   subscription_id: "#{subscription.id}",
                                   payment_type: 'GoCardless'

    session.delete(:plan)
  end

  def update_user_with_payment_mandate
    current_user.update_attributes mandate: "#{@complete_mandate.links.mandate}",
                                   gocardless_id: "#{@complete_mandate.links.customer}"
  end
end
