class User::StockService
  def initialize(user, question)
    @user = user
    @question = question
  end

  def stock
    @user.stocked_questions << @question unless stocked?
  end

  def unstock
    @user.stocks.find_by(question_id: @question.id).destroy! if stocked?
  end

  private

  def stocked?
    @user.stocked_questions.include?(@question)
  end
end
