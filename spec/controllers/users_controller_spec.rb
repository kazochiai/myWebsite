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
	
	describe "POST 'create'" do
	
		describe "failure" do
			before(:each) do
				@attr = { :name => "", :email => "",  :userType => -1, :password => "",
						  :password_confirmation => "" }
			end
			
			it "should not create a user" do	#verify that a failed create action doesn’t create a user in the database. 
				lambda do
				post :create, :user => @attr
				end.should_not change(User, :count)
			end
			
			it "should have the right title" do
				post :create, :user => @attr
				response.should have_selector("title", :content => "Sign up")
			end
			
			it "should render the 'new' page" do
				post :create, :user => @attr
				response.should render_template('new')
			end
		end
		
		describe "success" do
		
			before(:each) do
				@attr = { :name => "New User", :email => "user@example.com", :userType => 1,
	                      :password => "foobar", :password_confirmation => "foobar" }
	        end
	        
	        it "should create a user" do lambda do
		        post :create, :user => @attr end.should change(User, :count).by(1)
		    end
		    
		    it "should redirect to the user show page" do
			    post :create, :user => @attr
			    response.should redirect_to(user_path(assigns(:user)))
			end
			
			it "should sign the user in" do
				post :create, :user => @attr
				controller.should be_signed_in
			end
		end
	end
end
