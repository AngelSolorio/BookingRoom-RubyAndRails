class UsersController < ApplicationController
  include ErrorCode
  skip_before_action :verify_authenticity_token
  before_action :restrict_access, only: [:edit,:update]
  before_action :correct_user, only: [:edit,:update]
  
  def new
    @user=User.new
  end
  
  def index
    search = params[:search] 
    if search =~ User::VALID_EMAIL_REGEX
      filter = "email"
      #@matched_users = User.where('email LIKE ?',"%#{search}%")
      @ldap_users= User.search_in_ldap("#{search}*",filter)
      @matched_users = User.data_comparison_with_ldap(@ldap_users)
    elsif search
      filter = "name"
      #@matched_users = User.where('full_name LIKE ?', "%#{search}%")
      @ldap_users= User.search_in_ldap("#{search}*",filter)
      @matched_users = User.data_comparison_with_ldap(@ldap_users)      
    else
      @ldap_users= User.search_in_ldap("*",filter)
      @matched_users = User.data_comparison_with_ldap(@ldap_users) 
    end
    #Respond to the request
      respond_to do |format|
        format.html 
        format.json { render :json=> { users: @matched_users,
                                     success: true,
                                     }, status: 200 }
      end
  end
  
  def edit
  end
  
  def show
    @user=User.find(params[:id])  
  end
  
  def create
    @user = User.new(user_params)
    @user.password_confirmation=user_params[:password] if user_params[:password]
    @user.full_name = user_params[:first_name] + " " + user_params[:last_name] if (user_params[:first_name] && user_params[:last_name])
    if @user.save
      sign_in @user
      respond_to do |format|
        format.html { redirect_back_or root_path }
        format.json { render :json=>{ user: { id: @user.id,
                                              name: @user.full_name,
                                              email: @user.email },
                                      success:  true,
                                      token: @user.remember_token
                                      } , status: 200 }
      end
    else
      respond_to do |format|
        format.html { puts @user.errors.full_messages }
        format.json { render :json=>{ message: @user.errors.full_messages,
                                      error_code: ErrorCode::USER_VALIDATION
                                      },status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:first_name,:last_name,:full_name,:email,:title,:department,:company,:photo_file,:password,:password_confirmation)
  end
  
  def correct_user
    @user = User.find(params[:id])
    unless current_user?(@user)
      respond_to do |format|
        format.html { redirect_to(root_url) }
        format.json { render :json => {
                                    message: "Invalid user",
                                    error_code: ErrorCode::UNAUTHORIZED_USER
                                  }, status: :unauthorized }
      end
    end
  end
  
  def users_found(matched_users)
    @users_found = []
    matched_users.each do |user|
      @users_found << {
        id: user.id,
        name: user.full_name,
        email: user.email,
        title: user.title,
        department: user.department,
        company: user.company,
        image: user.photo_file
      }
    end
  end
end
