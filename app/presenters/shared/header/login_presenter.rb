class Shared::Header::LoginPresenter < Curly::Presenter
  presents :form

  def label(type)
    @form.label type
  end

  def input(type)
    case type
    when "password"
      @form.password_field type
    else
      @form.text_field type
    end
  end

  def submit
    @form.submit "Log in"
  end
end
