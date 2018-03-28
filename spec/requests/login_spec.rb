require 'rails_helper'

RSpec.describe 'Login', type: :request do
  it "displays the user's username after successful login" do
    user = FactoryBot.create(:user, password: 'password')

    get '/users/sign_in'
    assert_select 'form#new_user' do
      assert_select 'input[name=?]', 'user[username]'
      assert_select 'input[name=?]', 'user[password]'
      assert_select 'input[type=?]', 'submit'
    end

    sign_in user

    get root_path
    expect(controller.current_user).to eq(user)
    expect(response.body).to include(user.username)
  end
end
