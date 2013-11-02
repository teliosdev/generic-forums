class Shared::Header::InfoPresenter < Curly::Presenter

  def avatar
    current_user.gravatar_url default: "identicon", filetype: :png,
      size: 32
  end

  def user_name
    current_user.name
  end

  def link(to)
    "#"
  end

  def t(rans)
    rans.humanize
  end
end
