# Require all the top level files in argus/*.rb

Dir[File.dirname(__FILE__) + "/argus/*.rb"].sort.each do |pn|
  require "argus/#{File.basename(pn, '.rb')}"
end
