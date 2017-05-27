class UsersController < ApplicationController
  before_action :load_user

  def edit
    @user = current_user
  end

  def update
    if @user.update_attributes(permitted_attributes)
      redirect_to root_url
    else

    end
  end

  def show
    @payments = load_payments
  end

  private

  def load_user
    @user ||= User.find(params[:id])
  end

  def load_payments
    return if @user.gocardless_id.nil? && @user.stripe_token.nil?
    Array(load_gocardless_payments) | Array(load_stripe_payments)
  end

  def load_gocardless_client
    @gocardless_client ||= GoCardlessPro::Client.new(
      access_token: Rails.application.secrets.gocardless_token || ENV['gocardless_token'],
      environment: :sandbox
    )
  end

  def load_gocardless_payments
    return if @user.gocardless_id.nil?
    load_gocardless_client
    payments = @gocardless_client.payments
                                 .list(params: { customer: @user.gocardless_id })
                                 .records
    gocardless_payments = []
    payments.each { |payment| gocardless_payments << [payment, "gocardless"] }
    gocardless_payments
  end

  def load_stripe_payments
    return if @user.stripe_token.nil?
    payments = Stripe::Charge.list(customer: @user.stripe_token).data
    stripe_payments = []
    payments.each { |payment| stripe_payments << [payment, "stripe"] }
    stripe_payments
  end

  def permitted_attributes
    params.require(:user).permit(:email, :number, :sms_alerts)
  end
end
