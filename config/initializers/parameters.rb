GenieacsGui::Application.config.summary_parameters = YAML.load_file('config/summary_parameters.yml')
GenieacsGui::Application.config.index_parameters = YAML.load_file('config/index_parameters.yml')

GenieacsGui::Application.config.device_filters = {'Last inform' => ['_lastInform'], 'Tag' => ['_tags']}
GenieacsGui::Application.config.summary_parameters.each do |k, v|
  if not v.is_a?(Array)
    v = [v]
    GenieacsGui::Application.config.summary_parameters[k] = v
  end

  v.each do |vv|
    if vv.is_a?(String)
      GenieacsGui::Application.config.device_filters[k] ||= []
      GenieacsGui::Application.config.device_filters[k].push(vv)
    end
  end
end

GenieacsGui::Application.config.index_parameters.each do |k, v|
  v = Array(v)
  GenieacsGui::Application.config.index_parameters[k] = v

  v.each do |vv|
    GenieacsGui::Application.config.device_filters[k] ||= []
    GenieacsGui::Application.config.device_filters[k].push(vv)
  end
end

GenieacsGui::Application.config.device_filters.each {|k, v| v.uniq!}

module ParameterRenderers
  Dir['config/parameter_renderers/*.rb'].each {|file| load "./#{file}" }
end
GenieacsGui::Application.config.parameter_renderers = YAML.load_file('config/parameter_renderers.yml')

GenieacsGui::Application.config.parameters_edit = YAML.load_file('config/parameters_edit.yml')
