class UsersController < ApplicationController
  
  def new
    @title = "Sign up"
    @user = User.new
  end
  
  def show
    #Looks at User database, queries by id, and places data in the @user instance variable
    @user = User.find(params[:id])
    #Sets @title to the name of the user. This is then passed to the users helper file and used to set title.
    @title = @user.name
  end
  
  def create
    #Below is equivalent to @user = User.new(:name => "", :email => "", :password => "", :password_confirmation =>"")
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end

end
