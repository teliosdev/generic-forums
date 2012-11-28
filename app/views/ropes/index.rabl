collection @threads, :root => :threads, :object_root => false

attributes :id, :title, :board_id, :user_id, :created_at, :updated_at
attributes :posts_count => :posts

node :last_post do |t|
 last_post = t.posts.last
 {
		:user_id => last_post.id,
		:at			=> last_post.created_at
 }
end

node :thread_url do |t|
	board_rope_posts_path(t.board, t, :format => params[:format])
end
