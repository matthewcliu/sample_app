module UsersHelper

  # Utilizes the gravatar_image_tag method with email argument as the lookup
  def gravatar_for(user, options = {:size => 50})
    gravatar_image_tag(user.email.downcase, :alt => user.name,
                                            # CSS class for gravatars
                                            :class => 'gravatar',
                                            :gravatar => options)
  end

end
