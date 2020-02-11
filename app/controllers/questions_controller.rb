class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
    @user = @question.user
  end

  def create 
    @question = current_user.questions.build(question_params)
    if @question.save
      flash[:success] = '投稿しました'
      redirect_to question_path(@question.id)
    else
      flash[:danger] = '投稿に失敗しました'
      redirect_back(fallback_location: root_path)
    end
  end
  
  private
  def question_params
    params.require(:question).permit(:title, :content)
  end
end
