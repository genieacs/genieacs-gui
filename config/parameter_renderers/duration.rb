def duration(val)
  mm, ss = val.divmod(60)
  hh, mm = mm.divmod(60)
  "#{val} (#{hh}:#{mm}:#{ss})"
end

