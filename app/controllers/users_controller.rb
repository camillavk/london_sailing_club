class UsersController < ApplicationController
  before_action :load_user

  def edit
    @user = current_user
  end

  def update
    @current_page = request.env['HTTP_REFERER']
    if @user.update_attributes(permitted_attributes) && @current_page.include?('/edit')
      redirect_to root_url
    else
      redirect_to user_url(@user)
    end
  end

  def show
    @payments = load_payments
    @member_type = display_member_type
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
    payments.each { |payment| gocardless_payments << [payment, 'gocardless'] }
    gocardless_payments
  end

  def load_stripe_payments
    return if @user.stripe_token.nil?
    payments = Stripe::Charge.list(customer: @user.stripe_token).data
    stripe_payments = []
    payments.each { |payment| stripe_payments << [payment, 'stripe'] }
    stripe_payments
  end

  # rubocop:disable MethodLength
  def display_member_type
    if !@user.active
      "You haven't selected a membership yet"
    elsif @payments.nil?
      original_user_or_pay_as_you_go
    elsif last_active_payment?(2400)
      'You are an Annual member'
    elsif last_active_payment?(3600)
      'You are a Patron member'
    else
      "You haven't selected a membership yet"
    end
  end

  def permitted_attributes
    params.require(:user).permit(:email, :number, :sms_alerts, :first_name, :surname)
  end

  def last_active_payment?(amount)
    payment = @payments.first.first
    payment.amount == amount &&
      payment.status != 'cancelled' &&
      payment.charge_date > 1.year.ago
  end

  def original_user_or_pay_as_you_go
    case @user.payment_type
    when 'patron'
      'You are a Patron member'
    when 'standard'
      'You are an Annual member'
    else
      'You are a Pay As You Go Sailor'
    end
  end
end
