require 'spec_helper'

describe "Users" do
  
  describe "signup" do
    
    describe "failure" do
      
      it "should not make a new user" do
        lambda do
          integration_sign_up(User.new(:name => "", :email => "", :password => "", :password_confirmation => ""))
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      
      it "should make a new user" do
        lambda do
          integration_sign_up(User.new(:name => "Example User", :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar"))
          response.should render_template('users/show')
          response.should have_selector("div.flash.success", :content => "Welcome")
        end.should change(User, :count).by(1)
      end
    end
    
    describe "sign in/out" do
      
      describe "failure" do
        it "should not sign a user in" do
          integration_sign_in(User.new(:email => "", :password => ""))
          response.should have_selector("div.flash.error", :content => "Invalid")
        end
      end
      
      describe "success" do
        it "should sign a user in and out" do
          user = Factory(:user)
          integration_sign_in(user)
          controller.should be_signed_in
          click_link "Sign out"
          controller.should_not be_signed_in
        end
      end      
    end


  end
end
