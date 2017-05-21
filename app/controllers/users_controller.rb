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
    load_gocardless_client
    @payments = @gocardless_client.payments
                                  .list(params: { customer: @user.gocardless_id })
                                  .records
  end

  private

  def load_user
    @user ||= User.find(params[:id])
  end

  def load_gocardless_client
    @gocardless_client ||= GoCardlessPro::Client.new(
      access_token: Rails.application.secrets.gocardless_token,
      environment: :sandbox
    )
  end

  def permitted_attributes
    params.require(:user).permit(:email, :number)
  end
end
