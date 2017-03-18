class MicropostsController < ApplicationController
  before_action :authenticate_user
  before_action :authorize_user, only: :destroy

  def create
    @micropost = current_user.microposts.new micropost_params
    if @micropost.save
      redirect_to root_path, success: 'Micropost created.'
    else
      @feed_items = current_user.feed.page params[:page]
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost deleted'
    redirect_to request.referer || root_path
  end

  private
  def micropost_params
    params.require( :micropost ).permit( :content )
  end
  
  def authorize_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_path if @micropost.nil?
  end
end
