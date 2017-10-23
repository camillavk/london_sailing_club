feature 'Payment' do
  xscenario 'takes the payment details from cookies/cache' do
    given_a_user_has_come_from_wordpress
    when_they_login
    their_selected_plan_is_visible
  end

  xscenario 'prefills information from user details' do
    given_a_user_is_logged_in
    when_they_have_selected_a_payment_plan
    when_they_are_redirected_to_gocardless
    their_details_are_prefilled_in_gocardless
  end

  def when_they_login
    given_a_user_is_logged_in
  end

  def when_they_have_selected_a_payment_plan
    click_button 'Click here to change'
    click_link 'Patron member'
  end

  def when_they_are_redirected_to_gocardless
    expect(page).to have_content('Payment')
  end

  def their_details_are_prefilled_in_gocardless; end
end
