module SessionsHelper

  def sign_in(user)
    # Assigns the array [user.id, user.salt] to the key :remember_token in the cookie hash
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    #By creating current_user in the helper, it is available in both the view (default) and the controller (explicit add)
    self.current_user = user
  end

  #Sets instance variable to current user
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    #Sets instance variable to user in the token if it is blank - otherwise ignores
    # Same as @current_user = @current_user||user_from_remember_token
    # Signed in user is passed from page to page in this way
    @current_user ||= user_from_remember_token
  end
  
  # Some user is signed in because signed_in? is not nil
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    #Deletes the value corresponding to :remember_token key
    cookies.delete(:remember_token)
    #Sets current user to nil
    self.current_user = nil
  end

  def deny_access
    #Stores location of page that is being denied
    store_location
    #Note that flash can be embedded directly as an option in redirect_to
    #Equivalent redirect_to signin_path, :notice => "...."
    redirect_to(signin_path)
    flash[:notice] = "Please sign in to access page."
  end
  
  def current_user?(user)
    #Checks to see if current_user is the same as tested user
    user == current_user
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  private
  
    def user_from_remember_token
      # * allows one to pass an array into a function that expects multiple arguments. It effectively splits the array.
      # authenticate_with_salt takes two arguments (id, salt) but cookies.signed[:remember_me] returns an array [user.id, user.salt]
      User.authenticate_with_salt(*remember_token)
    end
    
    #Ensures [nil,nil] if there is no cookie set. Simply returning nil will break the test.
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
    
    #Stores the current request into session. Request is a built-in rails facility
    def store_location
      session[:return_to] = request.fullpath
    end
    
    #clears the return to value
    def clear_return_to
      session[:return_to] = nil
    end
    
end
