class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def authenticate_user
    unless current_user.present?
      store_location
      flash[:danger] = 'Please, log in.'
      redirect_to login_path
    end
  end
  alias_method :logged_in_user, :authenticate_user
end
