require 'net/ldap'
class SessionsController < ApplicationController
  include ErrorCode
  skip_before_action :verify_authenticity_token
  
  def new  
  end
  
  def create
    email = params[:session][:email]
    password = params[:session][:password]
    filter = "email" 
    LDAP.auth email, password
      if LDAP.bind && !email.blank? && !password.blank?
      # Login credentials were valid!
      @user = find_for_ldap(email,filter)
        if @user.persisted?
          sign_in @user
          respond_to do |format|
            format.html { redirect_back_or root_path }
            format.json { render :json=>{ user: { id: @user.id,
                                                  name: @user.first_name + " " + @user.last_name,
                                                  email: @user.email },
                                          success:  true,
                                          token: @user.remember_token
                                          } , status: 200 }
          end
        else
          #Unable to save the user into the db, return errors
          respond_to do |format|
            format.html { puts @user.errors.full_messages }
            format.json { render :json=>{ message: @user.errors.full_messages,
                                          error_code: ErrorCode::USER_VALIDATION
                                        } , status: :unprocessable_entity }
          end
        end
      else
        #Login credentials are invalid, return errors
        respond_to do |format|
        flash.now[:error] = 'Invalid email/password combination'
        format.html { render 'new' }
        format.json { render :json=> { success: false,
                                       message: LDAP.get_operation_result.message,
                                       token: nil,
                                       error_code: ErrorCode::INVALID_CREDENTIALS 
                                     } , status: :unprocessable_entity }
        end
    end
  end
  
  def destroy
    sign_out
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { render :json=>{success: true},:status=>200 }
    end
  end
  
  private
  
  def user_params(params)
    params.require(:user).permit(:first_name, :last_name,:full_name,:email,:title,:department,:company,:photo_file,:password,:password_confirmation)
  end
  
  #Search a user with a given email in LDAP...If the user is not in my db, create them
  def find_for_ldap(email,filter)
    ldap_user = User.search_in_ldap(email,filter)
    user = User.where(email: ldap_user.first.mail.first).first
    unless user
      pass = SecureRandom.urlsafe_base64
      parameters = ActionController::Parameters.new({
        user: {
          first_name: User.check_ldap_attribute(ldap_user.first,'first_name'),
          last_name: User.check_ldap_attribute(ldap_user.first,'last_name'),
          full_name: User.check_ldap_attribute(ldap_user.first,'full_name'),
          email: User.check_ldap_attribute(ldap_user.first,'email'),
          title: User.check_ldap_attribute(ldap_user.first,'title'),
          department: User.check_ldap_attribute(ldap_user.first,'department'),
          company: User.check_ldap_attribute(ldap_user.first,'company'),
          password: pass,
          password_confirmation: pass
        }
      })
      user = User.create(user_params(parameters))                           
    end
    user
  end
    
end
