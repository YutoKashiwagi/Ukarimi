class AnswersController < ApplicationController
  def create
    @answer = Answer.new(answer_params)
    @answer.user_id = current_user.id
    @answer.question_id = params[:question_id]
    @question = @answer.id
    if @answer.save
      flash[:success] = '回答しました'
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = '回答に失敗しました'
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])
    @answer.destroy!
    redirect_to question_path(@question.id), success: '削除しました'
  end

  private

  def answer_params
    params.require(:answer).permit(:content)
  end
end
