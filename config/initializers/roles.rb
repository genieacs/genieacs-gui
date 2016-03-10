case GenieacsGui::Application.config.auth_method
when :yml
  GenieacsGui::Application.config.permissions = YAML.load_file('config/roles.yml')
  GenieacsGui::Application.config.users = YAML.load_file('config/users.yml')
end
