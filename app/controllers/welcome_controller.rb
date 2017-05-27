class WelcomeController < ApplicationController
  before_action :set_selected_plan
  before_action :set_plan_price

  def index
    if incomplete_user?
      redirect_to edit_user_path(current_user)
    end
  end

  def change_plan
    session[:plan] = params[:plan]
    set_plan_price
    redirect_to request.referer || root_url
  end

  private

  def set_selected_plan
    session[:plan] = params[:plan] if params[:plan].present?
    @plan = session[:plan].present? ? session[:plan].capitalize : nil
  end

  def set_plan_price
    session[:price_in_cents] = if @plan == "Pay_as_you_sail"
                                 1200
                               elsif @plan == "Standard"
                                 2400
                               elsif @plan == "Patron"
                                 3600
                               else
                                 0
                               end
    @price = session[:price_in_cents]
  end

  def user_complete?
    current_user && current_user.email?
  end

  def incomplete_user?
    current_user && !current_user.email?
  end

  def ready_for_payment?
    user_complete? && @plan.present?
  end

  def active_member?
    user_complete? &&
    !current_user.payment_date.nil? &&
    current_user.payment_date > 1.year.ago
  end
end
