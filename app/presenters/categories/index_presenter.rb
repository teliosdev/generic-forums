class Categories::IndexPresenter < Curly::Presenter
  presents :categories

  def category_list
    render @categories
  end
end
