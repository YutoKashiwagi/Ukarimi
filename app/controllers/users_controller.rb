class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @questions = @user.questions.recent.
      includes(:best_answer, :tag_relationships, :categories).page(params[:page]).per(10)
    @answered_questions = @user.answered_questions.recent.distinct.all_includes.page(params[:page]).per(10)
    @posts = @user.posts.recent.includes(:tag_relationships, :categories, :likes).page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.js
    end
  end
end
