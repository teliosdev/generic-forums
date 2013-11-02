class Categories::CategoryPresenter < Curly::Presenter
  presents :category

  def name
    @category.name
  end

  def description
    @category.description
  end

  def link
    category_path @category
  end
end
