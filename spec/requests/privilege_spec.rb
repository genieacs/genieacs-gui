require 'rails_helper'

RSpec.describe 'Privilege', type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe 'View only role' do
    let(:role) { FactoryBot.create(:view_only) }

    before do
      FactoryBot.create(:user_role, user_id: user.id, role_id: role.id)
      sign_in user
    end

    it 'should see 2 tab' do
      get '/'
      expect(response.body).to include('Home')
      expect(response.body).to include('Devices')
      expect(response.body).not_to include('Faults')
      expect(response.body).not_to include('Presets')
      expect(response.body).not_to include('Objects')
      expect(response.body).not_to include('Provisions')
      expect(response.body).not_to include('Virtual Parameters')
      expect(response.body).not_to include('Files')
      expect(response.body).not_to include('Activity logs')
      expect(response.body).not_to include('Users')
      expect(response.body).not_to include('Roles')
    end

    it "should access devices" do
      get '/devices'
      expect(response.body).not_to include("You are not authorized to access this section.")
    end

    it "shouldn't access faults" do
      get '/faults'
      expect(response.body).to include("You are not authorized to access this section.")
    end

    it "shouldn't access presets" do
      get '/presets'
      expect(response.body).to include("You are not authorized to access this section.")
    end

    it "shouldn't access objects" do
      get '/objects'
      expect(response.body).to include("You are not authorized to access this section.")
    end

    it "shouldn't access provisions" do
      get '/provisions'
      expect(response.body).to include("You are not authorized to access this section.")
    end

    it "shouldn't access files" do
      get '/files'
      expect(response.body).to include("You are not authorized to access this section.")
    end

    it "shouldn't access logs" do
      get '/logs'
      expect(response.body).to include("You are not authorized to access this section.")
    end

    it "shouldn't access users" do
      get '/users'
      expect(response.body).to include("You are not authorized to access this section.")
    end

    it "shouldn't access roles" do
      get '/roles'
      expect(response.body).to include("You are not authorized to access this section.")
    end
  end

  describe 'User role' do
    let(:role) { FactoryBot.create(:user2) }

    before do
      FactoryBot.create(:user_role, user_id: user.id, role_id: role.id)
      sign_in user
    end

    it 'should see 4 tabs' do
      get '/'
      expect(response.body).to include('Home')
      expect(response.body).to include('Devices')
      expect(response.body).to include('Faults')
      expect(response.body).not_to include('Presets')
      expect(response.body).not_to include('Objects')
      expect(response.body).to include('Provisions')
      expect(response.body).not_to include('Virtual Parameters')
      expect(response.body).not_to include('Files')
      expect(response.body).not_to include('Activity logs')
      expect(response.body).not_to include('Users')
      expect(response.body).not_to include('Roles')
    end
  end

  describe 'Super User role' do
    let(:role) { FactoryBot.create(:super_user) }

    before do
      FactoryBot.create(:user_role, user_id: user.id, role_id: role.id)
      sign_in user
    end

    it 'should see 7 tab' do
      get '/'
      expect(response.body).to include('Home')
      expect(response.body).to include('Devices')
      expect(response.body).to include('Faults')
      expect(response.body).not_to include('Presets')
      expect(response.body).not_to include('Objects')
      expect(response.body).to include('Provisions')
      expect(response.body).not_to include('Virtual Parameters')
      expect(response.body).not_to include('Files')
      expect(response.body).to include('Activity logs')
      expect(response.body).to include('Users')
      expect(response.body).to include('Roles')
    end
  end

  describe 'Admin role' do
    let(:role) { FactoryBot.create(:admin) }

    before do
      FactoryBot.create(:user_role, user_id: user.id, role_id: role.id)
      sign_in user
    end

    it 'should see 5 tab' do
      get '/'
      expect(response.body).to include('Home')
      expect(response.body).to include('Devices')
      expect(response.body).to include('Faults')
      expect(response.body).not_to include('Presets')
      expect(response.body).not_to include('Objects')
      expect(response.body).to include('Provisions')
      expect(response.body).not_to include('Virtual Parameters')
      expect(response.body).not_to include('Files')
      expect(response.body).not_to include('Activity logs')
      expect(response.body).to include('Users')
      expect(response.body).not_to include('Roles')
    end
  end

  describe 'Super Admin role' do
    let(:role) { FactoryBot.create(:super_admin) }

    before do
      FactoryBot.create(:user)
      FactoryBot.create(:user_role, user_id: user.id, role_id: role.id)
      sign_in user
    end

    it "should see all tab" do
      get '/'
      expect(response.body).to include('Home')
      expect(response.body).to include('Devices')
      expect(response.body).to include('Faults')
      expect(response.body).to include('Presets')
      expect(response.body).to include('Objects')
      expect(response.body).to include('Provisions')
      expect(response.body).to include('Virtual Parameters')
      expect(response.body).to include('Files')
      expect(response.body).to include('Activity logs')
      expect(response.body).to include('Users')
      expect(response.body).to include('Roles')
    end

    it 'should can manage user' do
      get '/users'
      expect(response.body).to include('New user')
      expect(response.body).to include('Edit')
      expect(response.body).to include('Destroy')
    end
  end
end
