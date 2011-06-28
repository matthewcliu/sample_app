module SessionsHelper

  def sign_in(user)
    # Assigns the array [user.id, user.salt] to the key :remember_token in the cookie hash
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    #By creating current_user in the helper, it is available in both the view (default) and the controller (explicit add)
    self.current_user = user
  end

  #Stores state of the user to be signed in
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    #Sets instance variable if it is blank - otherwise ignaores
    @current_user ||= user_from_remember_token
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  
  private
  
    def user_from_remember_token
      # * allows one to pass an array into a function that expects multiple arguments. It effectively splits the array.
      # authenticate takes two arguments but cookies.signed[:remember_me] returns an array
      User.authenticate_with_salt(*remember_token)
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

end
