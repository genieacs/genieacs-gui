require 'rails_helper'

RSpec.describe 'User', type: :request do
  let(:role) { FactoryBot.create(:role) }
  let(:users) { FactoryBot.create_list(:user, 3) }

  it "can read user" do
    current_user = users.first
    FactoryBot.create(:user_role, user_id: current_user.id, role_id: role.id)
    FactoryBot.create(:privilege, action: 'read', weight: 1, resource: '/users', role_id: role.id)

    sign_in current_user
    get '/users'
    assert_select 'table.records' do
      assert_select 'tr', 3
      assert_select 'tr > td', { count: 0, text: current_user.username }
      assert_select 'tr > td', { count: 0, text: current_user.roles.pluck(:name).join(',') }
      assert_select 'tr > td', users[1].username
      assert_select 'tr > td', users[1].roles.pluck(:name).join(',')
      assert_select 'tr > td', users[2].username
      assert_select 'tr > td', users[2].roles.pluck(:name).join(',')
    end

    expect(response.body).to include(current_user.username)
  end

  it "can't read user" do
    current_user = users.first
    sign_in current_user
    get '/users'
    expect(response.body).to include("You are not authorized to access this section.")
  end
end
