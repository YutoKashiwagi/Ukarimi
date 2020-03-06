class AnswersController < ApplicationController
  before_action :set_answer, only: [:destroy, :edit, :update]
  before_action :set_question, only: [:create]

  def create
    @answer = current_user.answers.build(answer_params)
    if @answer.save
      flash[:success] = '回答しました'
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = '回答に失敗しました'
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @answer.destroy!
    flash[:success] = '削除しました'
    redirect_back(fallback_location: root_path)
  end

  def edit
  end

  def update
    if @answer.update(answer_params)
      redirect_to question_path(@answer.question.id), flash: { success: '回答を編集しました' }
    else
      flash[:danger] = '編集に失敗しました'
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = current_user.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:content, :question_id)
  end
end
