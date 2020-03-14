class FollowCategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category

  def create
    current_user.follow_category(@category)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  def destroy
    current_user.unfollow_category(@category)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  private

  def set_category
    @category = Category.find(params[:category_id])
  end
end
