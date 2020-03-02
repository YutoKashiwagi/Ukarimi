class LikesController < ApplicationController
  prepend_before_action :set_likable
  before_action :authenticate_user!

  def create
    @likable.liked_by(current_user)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @likable.unliked_by(current_user)
    redirect_back(fallback_location: root_path)
  end

  private

  def like_params
    params.require(:like).permit(:user_id)
  end
end
