json.partial! "partials/board_info", :board => @board

json.thread do |json|
  json.(@thread, :id, :title, :created_at, :updated_at)
  json.user do |json|
    json.(@thread.user, :id, :name)
  end
end
