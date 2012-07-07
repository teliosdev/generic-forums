json.(@board, :id, :name, :parent_id, :sub)

json.children.array!(@children) do |json, child|
  json.(child, :id, :name, :parent_id, :sub)
end
