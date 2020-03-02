class Answers::LikesController < LikesController
  private

  def set_likable
    @likable = Answer.find(params[:answer_id])
  end
end
