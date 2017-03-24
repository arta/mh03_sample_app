class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user = current_user # for /users/_stats
      @micropost = current_user.microposts.new
      @feed_items = current_user.feed.page params[:page]
    end
  end
  # Implicitly renders /static_pages/home with
  #   =render @feed_items
  #     implicitly renders /microposts/_micropost
  #     (which has access to a local variable 'micropost')
  #     because @feed_items is a collection of Micropost instances

  def help
  end
  
  def about
  end
  
  def contact
  end
end
