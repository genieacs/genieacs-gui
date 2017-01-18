module FaultsHelper
  def fault_detail(fault)
    return '' if not fault['detail']
    text = ''
    fault['detail'].each do |k, v|
      text += "\n\n" if text != ''
      text += "#{k.upcase}:\n#{v}"
    end
    return text
  end
end
