module DevicesHelper
  def get_param(path, device)
    #return device[path] if device.has_key?(path)

    ref = device
    nodes = path.split('.')
    pp = []
    for node in nodes
      pp << node
      p = pp.join('.')

      if ref.has_key?(p)
        ref = ref[p]
        pp = []
      end
    end
    if not pp.empty?
      return nil
    end
    return ref
  end

  def param_value(path, device)
    classes = ['long-text', 'param-value']

    param = get_param(path, device)
    return nil if param == nil

    if param.is_a?(Hash)
      val = param.include?('_orig')? param['_orig'] : param['_value']
      if param.include? '_timestamp'
        tooltip = 'title="as of ' + distance_of_time_in_words(@now, param['_timestamp'], include_seconds: true) + ' ago"'
      end
      classes << 'value-writable' if param['_writable']
    else
      val = param
    end

    valHtml = CGI::escapeHTML(val.to_s)
    bare_path = path.gsub(/\.\d+\./, '..')
    if Rails.configuration.parameter_renderers.has_key?(bare_path)
      begin
        valHtml = ParameterRenderers::send(Rails.configuration.parameter_renderers[bare_path], val)
      rescue => e
        logger.error("Exception in renderer '#{Rails.configuration.parameter_renderers[path]}' for value '#{val}': #{e}")
      end
    end

    if not classes.empty?
      cls = 'class="' + classes.join(' ') + '"'
    end

    "<span #{cls} #{tooltip}>#{valHtml}</span>".html_safe
  end
end
