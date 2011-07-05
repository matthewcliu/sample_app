class PagesController < ApplicationController

  #Basic methods that create views.
  def home
    #Sets @title to be "Home" for the home view
    @title = "Home"
    if signed_in?
      @micropost = Micropost.new
      #Aggregates user's feed items and paginates them
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end 
  end

  def contact       
    @title = "Contact"
  end
  
  def about
    @title = "About"
  end
  
  def help
    @title = "Help"
  end
  
end
