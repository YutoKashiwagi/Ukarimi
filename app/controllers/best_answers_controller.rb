class BestAnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question

  def update
    @answer = @question.answers.find(params[:id])
    return if @question.has_best_answer?
    if @question.update(update_params)
      flash[:success] = 'ベストアンサーを決定しました'
      redirect_to question_path(@question.id)
    else
      flash[:danger] = '失敗しました'
      redirect_to question_path(@question.id)
    end
  end

  private

  def set_question
    @question = current_user.questions.find(params[:question_id])
  end

  def update_params
    params.require(:question).permit(:best)
  end
end
