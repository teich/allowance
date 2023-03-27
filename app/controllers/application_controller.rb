class ApplicationController < ActionController::Base
  # ...
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate_user!
    redirect_to root_path, alert: 'You must be signed in to view this page.' unless current_user
  end

  def admin_user!
    if current_user
      allowed_emails = ['oren@teich.net', 'olivia@teich.net']
      unless allowed_emails.include?(current_user.email)
        redirect_to root_path, alert: 'You do not have permission to view this page.'
      end
    else
      redirect_to root_path, alert: 'You must be signed in to view this page.'
    end
  end
end
