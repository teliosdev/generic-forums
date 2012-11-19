object @post

attributes :id, :user_id, :format, :created_at, :updated_at
attributes :parent_id => :reply_to
attributes :body unless params[:show_parsed_body]

node :thread_url do |p|
  board_rope_path(p.board, p.rope)
end

node :parsed_body do |post|
  Formatter.new(post.body, post.format).render
end if params[:show_parsed_body]

child :rope do
  attributes :id, :title, :board_id, :user_id, :created_at, :updated_at
end
