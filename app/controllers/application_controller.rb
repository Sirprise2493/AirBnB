class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Allow these fields during sign-up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :photo])

    # Allow these fields during profile update
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :first_name,
      :last_name,
      :photo,
      :phone,
      :location,
      :bio,
      :birthdate,
      :gender,
      :occupation,
      :languages
    ])
  end
end

