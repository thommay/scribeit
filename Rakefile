begin
  require 'rubygems'
  require 'echoe'

  Echoe.new("scribeit") do |p|
    p.author = "Thom May"
    p.summary = "A configurable scribe client"
    p.runtime_dependencies = ['scribe >0.2.2', "eventmachine", "eventmachine-tail"]
    p.rdoc_pattern = /^(lib|bin|tasks|ext)|^README|^CHANGELOG|^TODO|^LICENSE|^COPYING$/
  end
rescue LoadError
end

