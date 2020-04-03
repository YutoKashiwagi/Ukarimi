class Questions::CommentsController < CommentsController
  private

  def set_commentable
    @commentable = Question.find(params[:question_id])
  end
end
