class MicropostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => [:destroy]

  def create  
    #.build because this is associated with a user. Pulls from :micropost parameter in input form
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created"
      #Redirects to home page
      redirect_to root_path
    else
      @feed_items = []
      render('pages/home')
    end
  end

  def destroy
    @micropost.destroy
    redirect_back_or root_path
  end
  
  private
    def authorized_user
      #Take the id of the micropost being clicked on for delete and store as instance variable.
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_path if @micropost.nil?
    end

end