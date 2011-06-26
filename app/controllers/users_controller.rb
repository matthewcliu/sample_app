class UsersController < ApplicationController
  
  def new
    @title = "Sign up"
  end
  
  def show
    #Looks at User database, queries by id, and places data in the @user instance variable
    @user = User.find(params[:id])
    #Sets @title to the name of the user. This is then passed to the users helper file and used to set title.
    @title = @user.name
  end

end
