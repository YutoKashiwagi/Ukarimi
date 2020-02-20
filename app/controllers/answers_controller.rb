class AnswersController < ApplicationController
  before_action :set_answer, only: [:destroy, :edit, :update]
  before_action :set_question, only: [:create, :edit, :destroy, :update]

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question_id = @question.id
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
    redirect_to question_path(@question.id), flash: { success: '削除しました' }
  end

  def edit
  end

  def update
    if @answer.update(answer_params)
      redirect_to question_path(@question.id), flash: { success: '回答を編集しました' }
    else
      redirect_to edit_question_answer_path(id: @answer.id, question_id: @question.id), flash: { danger: '編集に失敗しました' }
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
    params.require(:answer).permit(:content)
  end
end
