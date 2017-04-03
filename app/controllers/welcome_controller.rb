class WelcomeController < ApplicationController
  before_action :set_selected_plan
  before_action :set_plan_price

  def index
    if current_user && !current_user.email?
      redirect_to edit_user_path(current_user)
    else
    end
  end

  def change_plan
    session[:plan] = params[:plan]
    redirect_to request.referer
  end

  private

  def set_selected_plan
    session[:plan] ||= params[:plan]
    @plan = session[:plan].present? ? session[:plan].capitalize : nil
  end

  def set_plan_price
    @price = if @plan == "pay_as_you_sail"
               12
             elsif @plan == "Standard"
               24
             elsif @plan == "Patron"
               36
             else
               0
             end
  end
end
