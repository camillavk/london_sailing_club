require 'spec_helper'

describe UsersController do
  describe 'Get #show' do
    context 'should ask user to select member type' do
      it 'when not yet active' do
        user = create(:user)
        get :show, id: user
        expect(response.body).to match(/selected a membership yet/m)
      end
    end

    context 'should display the member type when selected' do
      before(:each) do
        user = create(:user, active: true)
        get :show, id: user
      end

      it 'when user is a pay as you sail member' do
        expect(response.body).to match(/Pay As You Go/m)
      end
    end

    context 'For initial users' do
      before(:each) do
        user = create(:user, active: true, payment_type: 'patron', payment_date: (Time.zone.today - 3.months))
        get :show, id: user
      end

      it 'shows the user member type' do
        expect(response.body).to match(/You are a Patron member/m)
      end
    end
  end
end
