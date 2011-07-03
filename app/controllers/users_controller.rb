class UsersController < ApplicationController
  
  #Only allows edit and update actions below after authenticate and correct user filters pass
  before_filter :authenticate, :only => [:edit, :update, :index, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
    
  def new
    @title = "Sign up"
    @user = User.new
  end
  
  def show
    #Looks at User database, queries by id, creates a hash, and places data in the @user instance variable
    @user = User.find(params[:id])
    #Sets @title to the name of the user. This is then passed to the users helper file and used to set title.
    @title = @user.name
  end
  
  def index
    @title = "All users"
    #paginate is a method of the will_paginate gem
    @users = User.paginate(:page => params[:page])
  end
  
  def create
    #Below is equivalent to @user = User.new(:name => "", :email => "", :password => "", :password_confirmation =>""). 
    #Values for params come from the form submission on the New page.
    @user = User.new(params[:user])
    if @user.save
      #After saving the created user, immediately sign them in
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      #Redirects to user page
      redirect_to @user
    else
      @title = "Sign up"
      # Change password and confirmation to nil BEFORE rendering the new page
      @user.password = nil
      @user.password_confirmation = nil
      render 'new'
    end
  end
  
  #Automatically adds method=post and value=put in the view - browsers cannot natively send PUT requests
  def edit
    #Checks up the current user in browser from params then finds details in the database
    @user = User.find(params[:id])
    @title = "Edit user"
  end
  
  def update
    #Look up current logged in user
    @user = User.find(params[:id])
    #If user successfuly updates with params :user from the entered form
    if @user.update_attributes(params[:user])
      flash[:success] = "User updated"
      redirect_to @user
    else
      @title = "Edit user"
      render "edit"
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_path
  end
  
  private
  
    def authenticate
      #Calls yet to be defined method deny_access (to be put in sessions since it is authentication) and signed_in? method
      deny_access unless signed_in?
    end
    
    def correct_user
      #Lookup user whose page is being accessed
      @user = User.find(params[:id])
      #If current_user is not @user, redirect to home page
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
        
end
