GenericDataFormatter.add_formatter :markdown do |body, options|
  RDiscount.new(body, :smart, :filter_html).to_html
end
