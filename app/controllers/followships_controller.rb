class FollowshipsController < ApplicationController
  before_action :authenticate_user
  # Another layer of security is repeated usage of current_user in both actions,
  #   see dev't note 3-24-17

  def create
    @user = User.find params[:followee_id]
    current_user.follow( @user )
    respond_to do |format|
      format.html { redirect_to @user }#{ redirect_back fallback_location: root_path }
      format.js
    end
  end

  def destroy
    @user = Followship.find( params[:id] ).followee
    current_user.unfollow( @user )
    respond_to do |format|
      format.html { redirect_to @user }# { redirect_back fallback_location: root_path }
      format.js
    end
  end
end
