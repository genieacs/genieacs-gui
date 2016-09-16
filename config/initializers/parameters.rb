GenieacsGui::Application.config.summary_parameters = YAML.load_file('config/summary_parameters.yml')
GenieacsGui::Application.config.index_parameters = YAML.load_file('config/index_parameters.yml')

GenieacsGui::Application.config.device_filters = {'Last inform' => '_lastInform', 'Tag' => '_tags'}
GenieacsGui::Application.config.device_filters.merge!(GenieacsGui::Application.config.summary_parameters)
GenieacsGui::Application.config.device_filters.merge!(GenieacsGui::Application.config.index_parameters)
GenieacsGui::Application.config.device_filters.delete_if {|key, value| not value.is_a?(String)}

module ParameterRenderers
  Dir['config/parameter_renderers/*.rb'].each {|file| load "./#{file}" }
end
GenieacsGui::Application.config.parameter_renderers = YAML.load_file('config/parameter_renderers.yml')

GenieacsGui::Application.config.parameters_edit = YAML.load_file('config/parameters_edit.yml')
