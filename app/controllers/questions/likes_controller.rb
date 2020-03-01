class Questions::LikesController < LikesController
  private

  def set_likable
    @likable = Question.find(params[:question_id])
  end
end
