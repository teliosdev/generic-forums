#File.open(File.join([Rails.root, "gf-plugins", "manifest"]), "r").lines do |line|
#  next if line =~ /\A\#/
#  require File.join(Rails.root, "gf-plugins", line.chomp)
#end
#a = GenericForums::Application.assets
#if a
#  Dir[File.join(Rails.root, "gf-plugins", "*")].each do |d|
#    next unless File.directory? d
#    a.append_path File.join(d, "vendor", "assets", "javascripts")
#    a.append_path File.join(d, "vendor", "assets", "stylesheets")
#  end
#end

#GenericForums::Application.assets.append_path File.join(Rails.root, "gf-plugins", "*", "vendor", "javscripts")
