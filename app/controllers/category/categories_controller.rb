class Category::CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @questions = @category.questions.page(params[:page]).per(10)
    @posts = @category.posts.page(params[:page]).per(10)
    @users = @category.users.page(params[:page]).per(10)
  end
end
