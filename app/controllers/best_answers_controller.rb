class BestAnswersController < ApplicationController
  before_action :authenticate_user!

  def update
    @question = current_user.questions.find(params[:id])
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

  def update_params
    params.require(:question).permit(:best)
  end
end
