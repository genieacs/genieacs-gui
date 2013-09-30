GenieacsGui::Application.config.summary_parameters = YAML.load_file('config/summary_parameters.yml')
GenieacsGui::Application.config.index_parameters = YAML.load_file('config/index_parameters.yml')

GenieacsGui::Application.config.device_filters = {'Last inform' => 'summary.lastInform', 'Tag' => '_tags'}
GenieacsGui::Application.config.device_filters.merge!(GenieacsGui::Application.config.summary_parameters)
GenieacsGui::Application.config.device_filters.merge!(GenieacsGui::Application.config.index_parameters)
