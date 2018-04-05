# Need to not fail when uri contains curly braces
# This overrides the DEFAULT_PARSER with the UNRESERVED key, including '{' and '}'
# DEFAULT_PARSER is used everywhere, so its better to override it once
module URI
  remove_const :DEFAULT_PARSER
  unreserved = REGEXP::PATTERN::UNRESERVED
  DEFAULT_PARSER = Parser.new(:UNRESERVED => unreserved + "\{\}\^")
end

GenieacsGui::Application.routes.draw do
  devise_for :users,
    controllers: { sessions: 'users/sessions', },
    skip: [:registrations]
  as :user do
    get 'users/edit' => 'users/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'users/registrations#update', :as => 'user_registration'
  end

  root 'home#index'
  get 'devices' => 'devices#index'
  get 'devices/:id' => 'devices#show'
  post 'devices/:id' => 'devices#update'
  delete 'devices/:id' => 'devices#destroy'

  get 'faults' => 'faults#index'
  delete 'faults/:id' => 'faults#destroy'
  post 'tasks/:id/retry' => 'faults#retry_task'
  delete 'tasks/:id' => 'faults#destroy_task'

  get 'presets' => 'presets#index'
  get 'presets/new' => 'presets#new'
  get 'presets/:id/edit' => 'presets#edit'
  post 'presets' => 'presets#update'
  delete 'presets/:id' => 'presets#destroy'

  get 'objects' => 'objects#index'
  get 'objects/new' => 'objects#new'
  get 'objects/:id/edit' => 'objects#edit'
  post 'objects' => 'objects#update'
  delete 'objects/:id' => 'objects#destroy'

  get 'provisions' => 'provisions#index'
  get 'provisions/new' => 'provisions#new'
  get 'provisions/:id/edit' => 'provisions#edit'
  post 'provisions' => 'provisions#update'
  delete 'provisions/:id' => 'provisions#destroy'

  get 'virtual_parameters' => 'virtual_parameters#index'
  get 'virtual_parameters/new' => 'virtual_parameters#new'
  get 'virtual_parameters/:id/edit' => 'virtual_parameters#edit'
  post 'virtual_parameters' => 'virtual_parameters#update'
  delete 'virtual_parameters/:id' => 'virtual_parameters#destroy'

  get 'files' => 'files#index'
  get 'files/new' => 'files#new'
  post 'files' => 'files#upload'
  delete 'files/:id' => 'files#destroy', :constraints => { :id => /.*/ }

  get 'ping/:ip' => 'ping#index', :constraints => { :ip => /[0-9\.]+|[0-9a-f:]+/ }

  resources :users do
    resources :user_roles
  end
  resources :roles, except: [:new, :create, :destroy] do
    resources :privileges
  end
  resources :logs, only: [:index]
  resources :offices, execpt: [:show]
  resources :cities, execpt: [:index, :show]
  resources :sector_cities, execpt: [:index, :show]
  resources :divisions, execpt: [:index, :show]
  resources :departments, execpt: [:index, :show, :destroy]

  if Rails.configuration.auth_method == :db
    get 'change_password' => 'change_password#index'
    post 'change_password' => 'change_password#update'
  end
end
