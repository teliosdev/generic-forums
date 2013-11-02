class Devise::CustomRegistrationsController < Devise::RegistrationsController
  after_filter :add_account
  before_filter :configure_permitted_parameters

  protected

  def add_account
    if resource.persisted?
      resource.set_default_groups
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end
end
