class WelcomeController < ApplicationController
  def index
    if current_user && !current_user.email?
      redirect_to edit_user_path(current_user)
    else
    end
  end
end
