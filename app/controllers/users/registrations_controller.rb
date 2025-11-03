class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # Redirect to user profile after updating
  def after_update_path_for(resource)
    user_profile_path
  end
end
