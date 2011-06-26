module UsersHelper

  # Utilizes the gravatar_image_tag method with email argument
  def gravatar_for(user, options = {:size => 50})
    gravatar_image_tag(user.email.downcase, :alt => user.name,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end

end
