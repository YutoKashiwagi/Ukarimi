class Admin::UsersController < ApplicationController
  before_action :check_admin
  def index
    @users = User.all
  end

  def destroy
    user = User.find(params[:id])
    user.destroy!
    flash[:success] = 'ユーザーを削除しました'
    redirect_back(fallback_location: root_path)
  end
end
