class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def current_user
    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
      session[:user_id] = nil
      nil
    end
  end
  helper_method :current_user

  def authorize
    redirect_to login_url, alert: "You must login first" if current_user.nil?
  end

  def authorize_admin
    redirect_to login_url, alert: "You must login first" unless current_user.try(:is_admin)
  end

  def login_user(user)
    @current_user = user
    session[:user_id] = user.id
  end
end
