class Category::CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @questions = @category.questions.recent.all_includes.page(params[:page]).per(10)
    @posts = @category.posts.includes(:user, :tag_relationships, :categories, :likes).page(params[:page]).per(10)
    @users = @category.users.page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.js
    end
  end
end
