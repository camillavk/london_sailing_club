feature "Payment" do
  scenario "takes the payment details from cookies/cache" do
    given_a_user_has_come_from_wordpress
    when_they_login
    their_selected_plan_is_visible
  end

  scenario "prefills information from user details" do
    given_a_user_is_logged_in
    if_they_have_selected_a_payment_plan
    their_details_are_prefilled_in_gocardless
  end

  def when_they_login
    given_a_user_is_logged_in
  end
end
