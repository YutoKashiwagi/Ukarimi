class LikesController < ApplicationController
  prepend_before_action :set_likable, only: :create
  before_action :authenticate_user!

  def create
    @likable.liked_by(current_user)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  def destroy
    like = current_user.likes.find(params[:id])
    @likable = like.likable
    @likable.unliked_by(current_user)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end
end
