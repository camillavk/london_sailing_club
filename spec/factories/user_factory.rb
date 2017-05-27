FactoryGirl.define do
  factory :user do
    email "john@email.com"
    password "password"
    sms_alerts true
  end
end
