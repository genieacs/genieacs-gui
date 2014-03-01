def is_authorized action, resource, permissions
  return false unless permissions.include? action
  resource = normalize_resource_path resource
  resource.gsub!(/\/\<[^\<\>]*\>\//, '/')
  permissions[action].each do |p|
    len = [p[1].length, resource.length].min
    if p[1][0, len] == resource[0, len]
      if p[1].length <= resource.length
        return p[0] > 0
      elsif p[0] > 0
        return true
      end
    end
  end
  return false
end

def normalize_permissions(permissions)
  permissions.each do |p|
    permissions.each do |p2|
      next if p[0] != p2[0] or p2 == p
      p2[1] = 0 if p2[2].start_with? p[2] and (p[1].abs > p2[1].abs or (p[1] < 0 and p[1] == p2[1]))
    end
  end

  permissions.each do |p|
    weight = 0
    length = 0
    permissions.each do |p2|
      next if p[0] != p2[0] or p2 == p

      if p2[2].length > length and p[2].start_with? p2[2]
        weight = p2[1]
        length = p2[2].length
      end
    end
    p[1] = 0 if weight != 0 and (weight + p[1]).abs == weight.abs + p[1].abs
  end

  permissions.delete_if {|p| p[1] == 0}
  permissions.sort! {|x, y| y[2].length <=> x[2].length}
  permissions_hash = {}
  permissions.each do |p|
    action = p[0].to_sym
    permissions_hash[action] = [] if not permissions_hash.include? action
    permissions_hash[action] << [p[1], p[2]]
  end
  return permissions_hash
end
