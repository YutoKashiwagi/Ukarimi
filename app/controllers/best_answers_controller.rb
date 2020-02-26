class BestAnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:best_answer][:question_id])
    best = @question.build_best_answer(best_answer_params)
    if best.save
      flash[:success] = 'ベストアンサーを決定しました'
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = '失敗しました'
      redirect_back(fallback_location: root_path)
    end
  end
  
  def destroy
  end

  private

  def best_answer_params
    params.require(:best_answer).permit(:question_id, :answer_id)
  end
end
