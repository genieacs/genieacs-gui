module DevicesHelper
  def get_value_from_path(device, path)
    ref = device
    nodes = path.split('.')
    for n in nodes
      ref = ref[n]
    end
    return ref
  end

  def param_value(path, device)
    classes = ['param-value']

    if device.has_key?(path)
      param = device[path]
    else
      begin
        param = get_value_from_path(device, path)
      rescue
        return ''
      end
    end

    if param.is_a?(Hash)
      val = param.include?('_orig')? param['_orig'] : param['_value']
      if param.include? '_timestamp'
        tooltip = 'title="as of ' + distance_of_time_in_words(@now, param['_timestamp'], include_seconds: true) + ' ago"'
      end
      classes << 'value-writable' if param['_writable']
    else
      val = param
    end

    if not classes.empty?
      cls = 'class="' + classes.join(' ') + '"'
    end

    "<span #{cls} #{tooltip}>#{val}</span>".html_safe
  end
end
