if Rails.env.development?
  %w[permission board_permission].each do |f|
    require_dependency File.join("app","models","#{f}.rb")
  end
end
