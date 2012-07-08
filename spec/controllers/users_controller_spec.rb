require 'spec_helper'

describe UsersController do
	render_views
	
	describe "GET 'new'" do
		it "should be successfull" do
			get 'new'
			response.should be_success
		end
		
		it "should have the right title" do
			get 'new'
			response.should have_selector("title", :content => "Sign up")
		end
	end
	
	
	describe "GET 'show'" do
		before(:each) do
			@user = Factory(:user)
		end
	
		it "should be successfull" do
			get :show, :id => @user
			response.should be_success
		end
		
		it "should find the right user" do
			get :show, :id => @user
			assigns(:user).should == @user #The assigns method takes in a symbol argument and returns the value of the corresponding instance variable in the controller action. P265
		end
				
		it "should have the right title" do
			get :show, :id => @user
			response.should have_selector("title", :content => @user.name)
		end
		
		it "should include the user's name" do
			get :show, :id => @user
			response.should have_selector("h1>img", :class => "gravatar") # h1>img makes sure that the img tag is inside the h1 tag. :class option to test the CSS class of the element in question.
		end
	end
end
