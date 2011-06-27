require 'spec_helper'

describe PagesController do

  render_views
  
  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  #def about @title = "About"end in the pages_controller makes this a passing test

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    #title variable in application.html.erb and application_helper.rb make this this a passing test

    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
                        :content => @base_title + " | About")    
      end
  end


  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      # Note that :content matches substrings - doesn't have to be exact match
      response.should have_selector("title",
                        :content => @base_title + " | Home")
      end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
                        :content => @base_title + " | Contact")
    end
  end
  
  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end
    it "should have the right title" do
      get 'help'
      response.should have_selector("title",
                        :content => @base_title + " | Help")
    end
  end
  
end
