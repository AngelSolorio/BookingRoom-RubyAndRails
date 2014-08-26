class SettingsController < ApplicationController
  before_action :restrict_access, only: [:edit, :update]
  
  def edit
    @security_user=!User.find_by_admin_type("security").nil? ? User.find_by_admin_type("security") : User.new
    @administrative_user=!User.find_by_admin_type("administrative").nil? ? User.find_by_admin_type("administrative") : User.new
    @parking_user =!User.find_by_admin_type("parking").nil? ? User.find_by_admin_type("parking") : User.new
  end
  
  def update
    @security_user=User.find_by_email(params[:security_user][:email]) if !params[:security_user].nil?
    @administrative_user= User.find_by_email(params[:administrative_user][:email]) if !params[:administrative_user].nil?
    @parking_user=User.find_by_email(params[:parking_user][:email]) if !params[:parking_user].nil?
    @security_user.update_attribute(:admin_type, "security") if !@security_user.nil?
    @administrative_user.update_attribute(:admin_type, "administrative") if !@administrative_user.nil?
    @parking_user.update_attribute(:admin_type, "parking") if !@parking_user.nil?
    flash.now[:success]="Updated!"
    redirect_to edit_settings_path
  end
end