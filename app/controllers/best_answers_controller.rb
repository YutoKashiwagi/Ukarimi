class BestAnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = current_user.questions.find(params[:question_id])
    @answer = @question.answers.find(params[:answer_id])
    @q_and_a_relationship = @question.build_q_and_a_relationship(answer: @answer)
    return if @question.has_best_answer?
    if @q_and_a_relationship.save
      flash[:success] = 'ベストアンサーを決定しました'
      redirect_to question_path(@question.id)
    else
      flash[:danger] = '失敗しました'
      redirect_to question_path(@question.id)
    end
  end
end
