class UsersController < ActionController::Base
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

  private

  def load_user
    @user ||= User.find(params[:id])
  end

  def permitted_attributes
    params.require(:user).permit(:email, :number)
  end
end
