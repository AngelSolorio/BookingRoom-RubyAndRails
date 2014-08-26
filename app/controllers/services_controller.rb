class ServicesController < ApplicationController
  before_action :restrict_access, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :admin_user, only: :destroy
  
  def index
    @services = Service.all
  end
  
  def new
    @service = Service.new
  end
  
  def edit
    @service = Service.find(params[:id])
  end
  
  def show
    @service = Service.find(params[:id])
  end
  
  def create
    @service = Service.new(service_params)
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to services_path
  end
  
  def update
    @service = Service.find(params[:id])
    if @service.update_attributes(service_params)
      flash[:success] = "Service updated"
      respond_to do |format|
        format.json
        format.html { redirect_to @service }
      end
    else
      render 'edit'
      respond_to do |format|
        format.json
        format.html { render 'edit' }
      end
    end
  end
  
  private
  
  def service_params
    params.require(:service).permit(:name,:photo_file)
  end
  
  def admin_user
    redirect_to(root_url) unless current_user.admin_type != 'none'
  end
  
end
