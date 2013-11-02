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

  def register
    link_to "Register", new_user_registration_path
  end

  def submit
    @form.submit "Log in"
  end
end
