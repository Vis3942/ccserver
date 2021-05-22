class ApplicationController < ActionController::Base
  include Pundit
  # after_action :verify_authorized, except: [:index, :new], unless: :active_admin_controller? 
  # #after_action :verify_policy_scoped, only: :index, unless: :active_admin_controller? 
  # after_action :verify_authorized, except: :index, unless: :devise_controller? 
  # # after_action :verify_policy_scoped, only: :index, unless: :devise_controller? 

  #after_action :verify_policy_scoped, only: :index, unless: :welcome_controller? 

  # after_action do
  #   byebug
  #   if self.class == WelcomeController
  #     true
  #   else
  #     verify_policy_scoped
  #   end
  # end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  #if Rails.env.production?
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
  #end

  def devise_controller?
    is_a?(Devise::SessionsController)
  end

  def welcome_controller?
    is_a?(WelcomeController)
  end

  def active_admin_controller?
    is_a?(ActiveAdmin::BaseController)
  end

  def authenticate_active_admin_user!
    authenticate_user!
    unless current_user.admin? or current_user.manufacturingtech? or current_user.s2?  or current_user.s1? or current_user.manufacturingtech? or current_user.logistics? or current_user.finance?
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

    private

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
    end
  
    def render_404
      flash[:alert] = "Access Denied!!!"
      redirect_to(request.referrer || root_path)
    end

end
