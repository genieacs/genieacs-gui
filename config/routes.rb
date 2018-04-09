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
             controllers: { sessions: 'users/sessions' },
             skip: [:registrations]
  as :user do
    get 'users/edit' => 'users/registrations#edit', as: :edit_user_registration
    put 'users' => 'users/registrations#update', as: :user_registration
  end

  authenticated :user do
    root to: 'home#index', as: :authenticated_root
  end

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

  get 'release_notes', to: 'home#release_notes'

  resources :users do
    resources :user_roles
  end

  resources :roles, except: %i[new create destroy] do
    resources :privileges
  end

  resources :parameters, only: %i[destroy] do
    collection do
      get 'download'
    end
  end

  resources :logs, only: %i[index]
  resources :departments, execpt: %i[index show destroy] do
    member do
      get 'divisions'
    end
  end
  resources :divisions, execpt: %i[index show] do
    member do
      get 'sector_cities'
    end
  end
  resources :sector_cities, execpt: %i[index show] do
    member do
      get 'cities'
    end
  end
  resources :cities, execpt: %i[index show] do
    member do
      get 'offices'
    end
  end
  resources :offices, execpt: %i[show]
  resources :cpe_configs, only: %i[index]

  if Rails.configuration.auth_method == :db
    get 'change_password' => 'change_password#index'
    post 'change_password' => 'change_password#update'
  end

  root to: redirect('/users/sign_in')
end
