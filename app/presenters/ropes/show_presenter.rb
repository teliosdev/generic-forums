class Ropes::ShowPresenter < Curly::Presenter
  presents :rope, :posts

  version 1
  depends_on 'posts/post'

  def post_list
    render @posts
  end

  def pagination
    paginate(@posts)
  end

  def pagination_info
    #page_entries_info(@posts)
    show_pages_for @posts
  end

  def cache_key
    [@rope.id, @rope.updated_at, current_user, @posts.current_page]
  end

  def cache_duration
    2.minutes
  end

  def new_post
    if can? :post, @rope
      post = Post.new rope_id: @rope.id
      form_for [@rope, post] do |f|
        render 'posts/new_form', post: post, form: f
      end
    end
  end
end
