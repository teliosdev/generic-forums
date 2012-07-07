json.(@board, :id, :name, :parent_id, :sub)
json.url json_url(@board)

json.children(@children) do |json, child|
  json.(child, :id, :name, :parent_id, :sub)
  json.url json_url(child)
end
