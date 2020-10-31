class ApplicationController < ActionController::Base

  def authenticate_active_admin_user!
    authenticate_user!
    unless current_user.admin? or current_user.techsupport?
      flash[:alert] = "unauthorized access"
      redirect_to new_user_session_path
    end

  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    def configure_permitted_parameters
        # # rails 4.x
        # devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password) }
        # devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :current_password) }
        #for rails 5.1 and above
        devise_parameter_sanitizer.permit(:sign_up) do |user|
          user.permit(:name, :email, :password)
        end
        devise_parameter_sanitizer.permit(:account_update) do |user|
          user.permit(:name, :email, :password, :current_password)
        end
    end



end
