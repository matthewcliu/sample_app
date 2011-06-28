class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end
  
  def create
    #Sets the user variable to the email and password entered in the form and hashed by params
    #Authenticate is a method defined in the user model to compare entered email/password with stored email/password
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      #Create an error message since the authentication failed
      flash.now[:error] = "Invalid email/password combination"
      #Re-render the page on a failed signin
      @title = "Sign in"
      render 'new'
    else
      #Sign in and redirect since the authentication will be true
      sign_in user
      redirect_to user
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end

end
