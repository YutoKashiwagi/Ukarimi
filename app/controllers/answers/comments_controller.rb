class Answers::CommentsController < CommentsController
  private

  def set_commentable
    @commentable = Answer.find(params[:answer_id])
  end
end
