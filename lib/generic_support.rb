module GenericSupport; end

%w(app_config formatter ghost options post_diff soft_destroy).each do |f|
  require "#{Rails.root}/lib/generic_support/#{f}"
end