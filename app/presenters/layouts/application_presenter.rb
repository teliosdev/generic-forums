class Layouts::ApplicationPresenter < Curly::Presenter

  def title
    content_for(:title) || Setting.forum.name
  end

  def stylesheets
    stylesheet_link_tag "application", media: "all"
  end

  def javascripts
    javascript_include_tag "application"
  end

  def csrf
    csrf_meta_tags
  end

  def body
    yield
  end

end
