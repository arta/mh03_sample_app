module SessionsHelper
  
  def log_in( user )
    session[:user_id] = user.id
  end

  def remember( user )
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # Return user from session or cookie if authenticated
  def current_user
    @current_user = 
      if user_id = session[:user_id]
        User.find_by id: user_id
      elsif user_id = cookies.signed[:user_id]
        user = User.find_by id: user_id
        if user.try :authenticated?, cookies[:remember_token]
          log_in user
          user
        end
      end
  end

  def current_user?( user )
    user == current_user
  end

  def logged_in?
    current_user.present?
  end

  def forget( user )
    user.forget
    cookies.delete( :user_id )
    cookies.delete( :remember_token )
  end
  
  def log_out
    forget current_user
    reset_session
  end
end
