class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.includes(:tag_relationships, :categories, :likes).recent
    @questions = @user.questions.includes(:best_answer, :tag_relationships, :categories).recent
    @answered_questions = @user.answered_questions.all_includes.recent
  end
end
