class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy,:edit, :update]
  def index
    @questions = Question.all
    @question = Question.new
    @answer = Answer.new
  end

  def show
    @question = Question.find(params[:id])
    @user = @question.user
    @answer = Answer.new
    @answers = @question.answers.all
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to question_path(@question.id), flash: { success: '投稿しました'}
    else
      redirect_to questions_path, flash: { danger: '投稿に失敗しました' }
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy!
    redirect_to questions_path, flash: {success: '削除しました'}
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    if @question.update(question_params)
      redirect_to question_path(@question.id), flash: { success: '質問を編集しました' }
    else
      redirect_to edit_question_path(@question.id), flash: { danger: '編集に失敗しました' }
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :content)
  end
end
