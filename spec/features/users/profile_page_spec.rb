feature 'User Profile' do
  scenario 'when they are logged in' do
    given_a_user_is_logged_in
    when_they_visit_their_profile_page
    then_they_should_see_their_email_address
  end

  scenario 'when they have made no payments' do
    given_a_user_is_on_their_profile_page
    when_they_have_made_no_payments
    then_they_should_see_no_payments
    and_they_should_see_a_link_to_the_payment_choices
  end

  scenario 'when they have made a gocardless payment' do
    given_a_gocardless_user_is_on_their_profile_page
    then_they_should_see_their_payment_details
  end

  scenario 'when they have made a stripe payment' do
    given_a_stripe_user_is_on_their_profile_page
    then_they_should_see_their_payment_details
  end

  scenario 'when they have made gocardless and stripe payments' do
    given_a_multipayment_user_is_on_their_profile_page
    then_they_should_see_multiple_payment_details
  end

  scenario 'they can opt out of SMS alerts' do
    given_a_user_is_on_their_profile_page
    when_they_click_on_the_opt_out_sms_checkbox
    then_they_will_be_opted_out_of_sms_alerts
  end

  scenario 'they can opt in to SMS alerts and add number' do
    given_a_user_is_on_their_profile_page
    when_they_click_on_the_opt_in_sms_checkbox
    and_they_provide_a_number
    then_they_will_be_opted_in_to_sms_alerts
  end

  def when_they_visit_their_profile_page
    VCR.use_cassette('gocardless_client') do
      visit user_path(@user)
    end
  end

  def then_they_should_see_their_email_address
    expect(page).to have_content @user.email
  end

  def given_a_user_is_on_their_profile_page
    given_a_user_is_logged_in
    when_they_visit_their_profile_page
  end

  def given_a_gocardless_user_is_on_their_profile_page
    @user = create(:user, gocardless_id: 'CU0001TPH9HG27')
    user_logs_in_and_visits_profile_page
  end

  def given_a_stripe_user_is_on_their_profile_page
    @user = create(:user, stripe_token: 'cus_AiWFtNzSvY3gpC')
    user_logs_in_and_visits_profile_page
  end

  def given_a_multipayment_user_is_on_their_profile_page
    @user = create(:user, stripe_token: 'cus_AiWFtNzSvY3gpC', gocardless_id: 'CU0001TPH9HG27')
    user_logs_in_and_visits_profile_page
  end

  def user_logs_in_and_visits_profile_page
    visit '/'
    click_link 'Already a member?'
    within all('.new_user').last do
      find('#user_email').set 'john@email.com'
      find('#user_password').set 'password'
    end
    click_button 'Login'
    VCR.use_cassette('gocardless_client') do
      visit user_path(@user)
    end
  end

  def when_they_have_made_no_payments
    @payments = []
  end

  def and_they_should_see_a_link_to_the_payment_choices
    expect(page).to have_content 'Click here to choose a plan'
  end

  def then_they_should_see_no_payments
    expect(page).to have_content "You haven't made any payments yet"
  end

  def then_they_should_see_their_payment_details
    expect(page).to have_content 'Amount'
    expect(page).to have_content 'Status'
  end

  def then_they_should_see_multiple_payment_details
    expect(page).to have_selector('table tr', minimum: 3)
  end

  def when_they_click_on_the_opt_out_sms_checkbox
    uncheck 'user_sms_alerts'
  end

  def when_they_click_on_the_opt_in_sms_checkbox
    check 'user_sms_alerts'
  end

  def then_they_will_be_opted_out_of_sms_alerts
    expect(find(:checkbox, 'user_sms_alerts')).to_not be_checked
  end

  def and_they_provide_a_number
    fill_in :user_number, with: '0777654326'
  end

  def then_they_will_be_opted_in_to_sms_alerts
    expect(find(:checkbox, 'user_sms_alerts')).to be_checked
  end
end
