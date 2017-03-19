feature "Registration" do
  scenario "multiple options" do
    given_a_user_is_on_the_registration_page
    they_should_have_two_registration_options_available
  end

  scenario "can successfully login via devise" do
    given_a_user_is_on_the_registration_page
    when_they_complete_the_email_registration
    then_they_click_the_registration_link
    then_they_should_see_a_success_message
  end

  scenario "can successfully login via meetup" do
    given_a_user_is_on_the_registration_page
    when_they_click_the_login_via_meetup_button
    and_they_complete_the_meetup_login
    then_they_are_asked_for_more_basic_info
  end

  def given_a_user_is_on_the_registration_page
    visit "/"
  end

  def they_should_have_two_registration_options_available
    expect(page).to have_content("Register with email")
    expect(page).to have_link("Login via Meetup")
  end

  def when_they_complete_the_email_registration
    fill_in :user_email, with: "example@email.com"
    fill_in :user_password, with: "password"
    fill_in :user_password_confirmation, with: "password"
    fill_in :user_number, with: "0777654326"
  end

  def then_they_click_the_registration_link
    click_button "Continue"
  end

  def then_they_should_see_a_success_message
    expect(page).to have_content "Welcome! You have signed up successfully."
  end

  def when_they_click_the_login_via_meetup_button
    click_link "Login via Meetup"
  end

  def and_they_complete_the_meetup_login
    mock_auth_hash
  end

  def then_they_are_asked_for_more_basic_info
    expect(page).to have_content "Successfully authenticated from Meetup account"
  end
end
