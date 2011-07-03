require 'spec_helper'

describe "FriendlyForwardings" do
  it "should forward to the requested page after signin" do
    user = Factory(:user)
    visit edit_user_path(user)
    #Sign in the user
    fill_in :email,   :with => user.email
    fill_in :password, :with => user.password
    click_button
    #Upon clicking, the should follow the redirect to the edit user page
    response.should render_template('users/edit')
  end
    
end
