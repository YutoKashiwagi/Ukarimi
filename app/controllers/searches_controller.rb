class SearchesController < ApplicationController
  before_action :set_search

  def index
    @categories = Category.all
  end

  private

  def set_search
    @search_questions = Question.ransack(params[:q])
    @searched_questions = @search_questions.result(distinct: true).recent.page(params[:page]).per(10)
  end
end
