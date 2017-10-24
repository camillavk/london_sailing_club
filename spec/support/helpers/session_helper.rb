module SessionHelper
  def when_they_are_on_the_registration_page
    visit '/'
  end

  def given_a_user_is_on_the_registration_page
    when_they_are_on_the_registration_page
  end

  def given_a_user_has_come_from_wordpress
    visit '/?plan=standard'
  end

  def their_selected_plan_is_visible
    expect(page).to have_content 'Standard membership'
  end

  def given_a_user_is_logged_in
    @user = create(:user)
    visit '/'
    click_link 'Already a member?'
    within all('.new_user').last do
      find('#user_email').set 'john@email.com'
      find('#user_password').set 'password'
    end
    click_button 'Login'
  end
end
