# Need to not fail when uri contains curly braces
# This overrides the DEFAULT_PARSER with the UNRESERVED key, including '{' and '}'
# DEFAULT_PARSER is used everywhere, so its better to override it once
module URI
  remove_const :DEFAULT_PARSER
  unreserved = REGEXP::PATTERN::UNRESERVED
  DEFAULT_PARSER = Parser.new(:UNRESERVED => unreserved + "\{\}\^")
end

GenieacsGui::Application.routes.draw do
  root 'home#index'
  get 'devices' => 'devices#index'
  get 'devices/:id' => 'devices#show'
  post 'devices/:id' => 'devices#update'

  get 'faults' => 'faults#index'
  post 'faults/:id/retry' => 'faults#retry'
  delete 'faults/:id' => 'faults#destroy'

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

  get 'files' => 'files#index'
  get 'files/new' => 'files#new'
  post 'files' => 'files#upload'
  delete 'files/:id' => 'files#destroy', :constraints => { :id => /[0-9A-Za-z_\-\.\/\%]+/ }

  get 'ping/:ip' => 'ping#index', :constraints => { :ip => /[0-9\.]+/ }
end
