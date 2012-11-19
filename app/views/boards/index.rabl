collection @boards, :root => :boards, :object_root => false

attributes :id, :name, :parent_id, :position, :sub, :created_at, :updated_at
attributes :ropes_count => :threads,
  :posts_count => :posts

node :threads_url do |b|
  board_ropes_path(b, :format => params[:format])
end
