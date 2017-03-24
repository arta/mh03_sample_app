class MicropostsController < ApplicationController
  before_action :authenticate_user
  before_action :authorize_user, only: :destroy

  def create
    @micropost = current_user.microposts.new micropost_params
    if @micropost.save
      redirect_to root_path, success: 'Micropost created.'
    else
      @user = current_user # for /users/_stats 
      @feed_items = current_user.feed.page params[:page]
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_back fallback_location: root_path, 
      flash: { success: 'Micropost deleted' }
  end

  private
  def micropost_params
    params.require( :micropost ).permit( :content, :picture )
  end
  
  def authorize_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_path if @micropost.nil?
  end
end
