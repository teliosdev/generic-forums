require 'diff/lcs/hunk'
require "#{Rails.root}/lib/generic_forums"
include GenericForums

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag
end
