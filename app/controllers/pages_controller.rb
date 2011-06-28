class PagesController < ApplicationController

  #Basic methods that create views.
  def home
    #Sets @title to be "Home" for the home view
    @title = "Home"
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
