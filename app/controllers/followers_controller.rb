class FollowersController < ApplicationController
  before_action :set_user
  def index
    @followers = @user.followers.page(params[:page]).per(10)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
