class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.includes(:tag_relationships, :categories, :likes).recent.page(params[:page]).per(10)
    @questions = @user.questions.includes(:best_answer, :tag_relationships, :categories).
      recent.page(params[:page]).per(10)
    @answered_questions = @user.answered_questions.distinct.all_includes.recent.page(params[:page]).per(10)
  end
end
