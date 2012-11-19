collection @posts, :object_root => false

attributes :id, :user_id, :rope_id, :created_at, :updated_at
attributes :parent_id => :reply_to
attributes :body, :format if params[:show_body]

node :post_url do |p|
  board_rope_post_path(p.board, p.rope, p, :format => params[:format])
end

node :thread_url do |p|
  board_rope_path(p.board, p.rope, :format => params[:format])
end

node :parsed_body do |post|
  Formatter.new(post.body, post.format).render
end if params[:show_parsed_body]

child :rope do
  attributes :id, :title, :board_id, :user_id, :created_at, :updated_at
end if params[:show_rope]
