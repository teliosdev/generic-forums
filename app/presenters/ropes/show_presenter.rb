class Ropes::ShowPresenter < Curly::Presenter
  presents :rope, :posts

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
end
