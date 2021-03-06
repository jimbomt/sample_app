class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  #before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :signedin_user, :only => [:new, :create]
  before_filter :admin_user, :only => :destroy
  
  def new
    @title = "Sign up"
    @user = User.new
  end
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
    respond_to do |format|
      format.html
      format.xml { render :xml => User.all.to_xml }
    end
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end
  
  def edit
    #@user = User.find(params[:id])
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
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    
    respond_to do |format|
      format.html { render 'show_follow' }
      format.xml { render :xml => @user.following.all.to_xml }
    end
      
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    
    respond_to do |format|
      format.html { render 'show_follow' }
      format.xml { render :xml => @user.followers.all.to_xml }
    end
    
  end
  
  def microposts
    @user = User.find(params[:id])
    respond_to do |format|
      format.xml { render :xml => @user.microposts.all.to_xml }
    end
  end
  
  private
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
    def signedin_user
      redirect_to(root_path) if signed_in?
    end

end
