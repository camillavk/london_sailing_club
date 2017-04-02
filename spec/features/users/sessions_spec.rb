feature "Sessions" do
  scenario "can login with devise if already signed up" do
    given_a_user_is_on_the_registration_page
    and_they_click_the_login_button
    they_are_able_to_login_via_devise
  end

  scenario "can logout" do
    given_a_user_is_logged_in
    when_they_click_the_logout_link
    they_are_able_to_logout
  end

  def given_a_user_is_on_the_registration_page
    user = create(:user)
    visit "/"
  end

  def and_they_click_the_login_button
    expect(page).to have_content "Login"
    click_link "Already a member?"
  end

  def they_are_able_to_login_via_devise
    within all(".new_user").last do
      find("#user_email").set "john@email.com"
      find("#user_password").set "password"
    end
    click_button "Login"
    expect(page).to have_content "Sign Out"
  end

  def given_a_user_is_logged_in
    user = create(:user)
    visit "/"
    click_link "Already a member?"
    within all(".new_user").last do
      find("#user_email").set "john@email.com"
      find("#user_password").set "password"
    end
    click_button "Login"
  end

  def when_they_click_the_logout_link
    click_link "Sign Out"
  end

  def they_are_able_to_logout
    expect(page).to have_content("Register with email")
    expect(page).to have_link("Login via Meetup")
  end
end
