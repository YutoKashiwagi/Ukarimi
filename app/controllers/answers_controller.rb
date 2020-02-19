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
    redirect_to question_path(@question.id), flash: { success: '削除しました' }
  end

  def edit
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])
  end

  def update
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])
    if @answer.update(answer_params)
      redirect_to question_path(@question.id), flash: { success: '回答を編集しました' }
    else
      redirect_to edit_question_answer_path(id: @answer.id, question_id: @question.id), flash: { danger: '編集に失敗しました'}
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:content)
  end
end
