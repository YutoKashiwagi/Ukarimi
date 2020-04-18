class BestAnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = current_user.questions.find(params[:question_id])
    @answer = @question.answers.find(params[:answer_id])
    if @question.decide_best_answer(@answer)
      @question.create_notification_best_answer(@answer)
      flash[:success] = 'ベストアンサーを決定しました'
      redirect_to question_path(@question.id)
    else
      flash[:danger] = '失敗しました'
      redirect_to question_path(@question.id)
    end
  end
end
