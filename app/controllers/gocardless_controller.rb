class GocardlessController < ApplicationController
  before_action :load_gocardless_client

  def mandate_and_payment
    if current_user.mandate?
      collect_payment
      render 'complete_mandate'
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
      access_token: Rails.application.secrets.gocardless_token,
      environment: :sandbox
    )
  end

  def create_mandate
    @redirect_flow = @gocardless_client.redirect_flows.create(
      params: {
        description: 'London Sailing Club Membership',
        session_token: "#{current_user.id}",
        success_redirect_url: 'http://localhost:3000/gocardless/complete_mandate', # Success page
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
    elsif session[:plan] == 'one-off'
      one_off_payment
    else
      subscription_payment
    end
  end

  def one_off_payment
    payment = @gocardless_client.payments.create(
      params: {
        amount: "#{session[:price_in_cents]}",
        currency: 'GBP',
        links: {
          mandate: "#{current_user.mandate}"
        },
        metadata: {
          plan: "#{session[:plan]}"
        }
      },
      headers: {
        'Idempotency-Key' => "#{session[:plan]}_#{Date.today}"
      }
    )
    current_user.update_attributes payment_date: Date.today,
                                   payment_amount: "#{Money.new(session[:price_in_cents], 'GBP')}",
                                   last_payment_id: "#{payment.id}",
                                   payment_type: 'GoCardless'
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
        'Idempotency-Key': "#{session[:plan]}_#{Date.today}"
      }
    )
    binding.pry
    current_user.update_attributes payment_date: Date.today,
                                   payment_amount: "#{Money.new(session[:price_in_cents], 'GBP')}",
                                   subscription_id: "#{subscription.id}",
                                   payment_type: 'GoCardless'
  end

  def update_user_with_payment_mandate
    current_user.update_attributes mandate: "#{@complete_mandate.links.mandate}",
                                   gocardless_id: "#{@complete_mandate.links.customer}"
  end
end
