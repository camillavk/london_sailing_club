class StripeChargesController < ApplicationController
  rescue_from Stripe::CardError, with: :catch_exception

  def new; end

  def create
    StripeChargesServices.new(charges_params, current_user).call
    update_user_with_payment_details
    redirect_to user_path(current_user)
  end

  private

  def charges_params
    params.permit(:stripeEmail, :stripeToken, :order_id)
  end

  def catch_exception(exception)
    flash[:error] = exception.message
  end

  def update_user_with_payment_details
    current_user.update_attributes payment_date: Time.zone.today,
                                   payment_amount: Money.new(2600, 'GBP').to_s,
                                   payment_type: 'Stripe'
  end
end
