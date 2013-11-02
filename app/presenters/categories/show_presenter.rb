class Categories::ShowPresenter < Curly::Presenter
  presents :category, :ropes

  def thread_list
    render @ropes
  end

  def pagination
    paginate @ropes
  end

  def t(translate)
    translate.titleize
  end
end
