class Posts::NewFormPresenter < Curly::Presenter
  presents :post, :form

  def format
    @form.select :format, GenericDataFormatter.formats
  end

  def body
    @form.text_area :body
  end

  def submit
    @form.submit
  end

  def reply_to
    @form.hidden_field :reply_to
  end

  def quote
    if params[:reply]
      post = Post.find(params[:reply])
      content_tag(:div, class: "reply-body", data: { format: post.format }) do
        post.body
      end
    else
      ""
    end
  end
end
