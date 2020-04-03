class FolloweesController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!, only: [:create, :destroy]
  def index
    @followees = @user.followees.page(params[:page]).per(10)
  end

  def create
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  def destroy
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
