class UsersController < ApplicationController
	before_filter :authenticate, :only => [:edit, :update]
	before_filter :admin_or_correct_user, :only => [:edit, :update]
	before_filter :authenticateAdmin, :only => [:index, :new, :destroy]


	def index
		@user = User.all
		@title = "All Users"
	end
	def new
		@user = User.new
		@title = "Sign up"
	end
	
	def show
		@user = User.find(params[:id]) 
		@title = @user.name
	end
	
	def create
		@user = User.new(params[:user])
		
		if @user.save
			sign_in @user
			 flash[:success] = "Sign up success."
			redirect_to @user
		else
		   @title = "Sign up"
		   render 'new'
		end
	end	
	
	def edit
   		@user = User.find(params[:id])
   		@title = "Edit user"
    end
    
    def update
    	@user = User.find(params[:id])
    	if @user.update_attributes(params[:user])
    		flash[:success] = "Profile updated."
    		redirect_to @user
    	else
    		@title = "Edit user"
    		render 'edit'
    	end
    end
    
    def destroy
    	User.find(params[:id]).destroy
    	flash[:success] = "User has been removed from database."
    	redirect_to users_path
    end
    
    private
    	def authenticate
    		deny_access unless signed_in?
    	end
    	
    	def correct_user
    		@user = User.find(params[:id])
    		redirect_to("/404.html") unless current_user?(@user)
    	end
    	
    	def admin_or_correct_user
    		@user = User.find(params[:id])
    		redirect_to("/404.html") unless is_admin? || current_user?(@user)
    	end
    	
    	def authenticateAdmin
    		deny_access unless is_admin?
    	end
end
