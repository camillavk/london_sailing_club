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

  scenario "it knows what payment plan you have selected" do
    given_a_user_has_come_from_wordpress
    when_they_are_on_the_registration_page
    their_selected_plan_is_visible
  end

  scenario "it allows you to change your selected payment plan" do
    given_a_user_has_come_from_wordpress
    when_they_are_on_the_registration_page
    when_they_change_their_plan_selection
    their_new_selected_plan_is_visible
  end

  def given_a_user_is_on_the_registration_page
    user = create(:user)
    visit "/"
  end

  def given_a_user_has_come_from_wordpress
    visit "/?plan=free"
  end

  def when_they_are_on_the_registration_page
    visit "/"
  end

  def their_selected_plan_is_visible
    expect(page).to have_content "Free membership"
  end

  def when_they_change_their_plan_selection
    click_button "Click here to change"
    click_link "Patron member"
  end

  def their_new_selected_plan_is_visible
    expect(page).to have_content "Patron membership"
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
