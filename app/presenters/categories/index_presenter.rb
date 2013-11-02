class Categories::IndexPresenter < Curly::Presenter
  presents :categories

  def category_list
    render @categories
  end

  def t(translate)
    translate.titleize
  end
end
