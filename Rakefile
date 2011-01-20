begin
  require 'rubygems'
  require 'echoe'

  Echoe.new("scribeit") do |p|
    p.author = "Thom May"
    p.summary = "A configurable scribe client"
    p.dependencies = ['scribe', "eventmachine", "eventmachine-tail"]
    p.rdoc_pattern = /^(lib|bin|tasks|ext)|^README|^CHANGELOG|^TODO|^LICENSE|^COPYING$/
  end
rescue LoadError
end

