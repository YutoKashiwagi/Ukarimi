class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_search

  def configure_permitted_parameters
    # 新規登録時
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    # 編集時
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :profile_image])
  end

  def set_search
    @search_questions = Question.ransack(params[:q])
    @searched_questions = @search_questions.result(distinct: true).recent
  end
end
