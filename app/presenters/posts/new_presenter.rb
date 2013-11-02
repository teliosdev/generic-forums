class Posts::NewPresenter < Curly::Presenter

  presents :post

  def form
    form_for [:rope, @post] do |f|
      render 'posts/new_form', post: @post, form: f
    end
  end
end
