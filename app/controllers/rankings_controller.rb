class RankingsController < ApplicationController
  def index
    @users_answers = User.create_ranking(Answer)
    @users_questions = User.create_ranking(Question)
  end
end
