module ApplicationHelper

#Logo exercise
  def logo
    image_tag("logo.png", :alt => "Sample App", :class => "round")
  end
  
#Return a title on a per page basis with a shared Base title
  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

end
