class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.recent
    @questions = @user.questions.recent
    @answered_questions = @user.answered_questions.recent
  end
end
