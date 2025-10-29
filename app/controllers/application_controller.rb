class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # Allow other fields
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Allow following fields for regisering
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :photo])

    # Allow following fields for Profile update
    # email, password and password confirmation are devise standart and do not need to be allowed
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :photo])
  end
end
