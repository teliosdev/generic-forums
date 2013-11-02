class Posts::NewFormPresenter < Curly::Presenter
  presents :post, :form

  def format

  end

  def body
    @form.text_area :body
  end

  def submit
    @form.submit
  end
end
