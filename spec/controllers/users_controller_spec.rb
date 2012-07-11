require 'spec_helper'

describe UsersController do
	render_views
	
	# describe "GET 'index'" do
# 		it "should not be successfull" do
# 			get 'index'
# 			response.should redirect_to(signup_path)
# 		end
# 	end
	
	#Rewrite for only admin access
	# describe "GET 'new'" do
# 		it "should be successfull" do
# 			get 'new'
# 			response.should be_success
# 		end
# 		
# 		it "should have the right title" do
# 			get 'new'
# 			response.should have_selector("title", :content => "Sign up")
# 		end
# 	end
	
	
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
	        
	        it "should create a user" do 
	        lambda do
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
	
	describe "GET 'edit'" do
	
		before(:each) do
			@user = Factory(:user)
			test_sign_in(@user)
		end
		
		it "should be successful" do
			get :edit, :id => @user
			response.should be_success
		end
		
		it "should have the right title" do
			get :edit, :id => @user
			response.should have_selector("title", :content => "Edit user")
		end
	end
	
	describe "PUT 'update'" do
		before(:each) do
			@user = Factory(:user) 
			test_sign_in(@user)
		end
		
		describe "failure" do
			before(:each) do
				@attr = { :email => "", :name => "", :password => "",:password_confirmation => "" }
			end
			
			it "should render the 'edit' page" do
				put :update, :id => @user, :user => @attr
				response.should render_template('edit')
			end
			
			it "should have the right title" do
				put :update, :id => @user, :user => @attr
				response.should have_selector("title", :content => "Edit user")
			end
		end
		
		describe "success" do
			before(:each) do
				@attr = { :name => "New Name", :email => "user@example.org",:password => "barbaz", :password_confirmation => "barbaz" }
			end
			
			it "should change the user's attributes" do
				put :update, :id => @user, :user => @attr
				@user.reload
				@user.name.should == @attr[:name]
				@user.email.should == @attr[:email]
			end
			
			it "should redirect to the user show page" do
				put :update, :id => @user, :user => @attr
				response.should redirect_to(user_path(@user))
			end
			
			it "should have a flash message" do
				put :update, :id => @user, :user => @attr
				flash[:success].should = ~/updated/
			end
		end
	end
	
	describe "authentication of edit/update pages" do
		before(:each) do
			@user = Factory(:user)
		end
		
		describe "for non-signed-in users" do
			it "should deny access to 'edit'" do
				get :edit, :id => @user
				response.should redirect_to("/404.html")
			end
			
			it "should deny access to 'update'" do
				put :update, :id => @user, :user => {}
				response.should redirect_to("/404.html")
			end
		end
	
		describe "for signed-in users" do
			before(:each) do
				wrong_user = Factory(:user, :email => "user@example.net", :userType => 1)
				test_sign_in(wrong_user)
			end
			
			it "should require matching users for 'edit'" do
				get :edit, :id => @user
				response.should redirect_to("/404.html")
			end
			
			it "should require matching users for 'update'" do
				put :update, :id => @user, :user => {}
				response.should redirect_to("/404.html")
			end
		end
	end
	
	# describe "authentication of showing user list" do 
# 		before(:each) do
# 			@user = Factory(:user, :userType => 1)
# 		end
# 		
# 		describe "as a non-signed-in user" do
# 			it "should deny access" do
# 				get :index
# 				response.should redirect_to("/404.html")
# 			end
# 		end
# 		
# 		describe "as a non-admin user" do
# 			it "should protect the page" do
# 				test_sign_in(@user)
# 				get :index, :id => @user
# 				response.should redirect_to("/404.html")
# 			end
# 		end
# 		
# 		before(:each) do
# 			admin = Factory(:user, :email => "admin@example.com", :userType => 0)
# 				test_sign_in(admin)
# 		end
# 		
# 		describe "for admin users" do
# 			it "should access to '/users'" do
# 				get :index
# 				response.should redirect_to(users_path)
# 			end
# 		end
# 	end
	
	describe "DELETE 'destroy'" do
	
		before(:each) do
			@user = Factory(:user)
		end
		
		describe "as a non-signed-in user" do
			it "should deny access" do
				delete :destroy, :id => @user
				response.should redirect_to("/404.html")
			end
		end
		
		describe "as a non-admin user" do
			it "should protect the page" do
				test_sign_in(@user)
				delete :destroy, :id => @user
				response.should redirect_to("/404.html")
			end
		end
		
		describe "as an admin user" do
			before(:each) do
				admin = Factory(:user, :email => "admin@example.com", :userType => 0)
				test_sign_in(admin)
			end
			
			it "should destroy the user" do
				lambda do
					delete :destroy, :id => @user
				end.should change(User, :count).by(-1)
			end
			
			it "should redirect to the users page" do
				delete :destroy, :id => @user
				response.should redirect_to(users_path)
			end
		end
	end
end
