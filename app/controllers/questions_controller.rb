class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy, :edit, :update]
  before_action :set_answer, only: [:index, :show]
  before_action :set_question, only: [:edit, :update, :destroy]

  def index
    @questions = Question.all_includes.recent.page(params[:page]).per(10)
    if user_signed_in?
      @followees_questions = current_user.followee_items(Question).all_includes.page(params[:page]).per(10)
      @mycategory_questions = current_user.mycategory_items(Question).all_includes.page(params[:page]).per(10)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @question = Question.find(params[:id])
    @related_questions = @question.related_questions
    @user = @question.user
    @answers = @question.answers.includes(:user, :likes, :comments)
  end

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.new(question_params)
    @question.set_taggable
    if @question.save
      redirect_to question_path(@question.id), flash: { success: '投稿しました' }
    else
      flash.now[:danger] = '投稿に失敗しました'
      render action: :new
    end
  end

  def destroy
    @question.destroy!
    redirect_to questions_path, flash: { success: '削除しました' }
  end

  def edit
  end

  def update
    if @question.update(question_params)
      @question.set_taggable
      redirect_to question_path(@question.id), flash: { success: '質問を編集しました' }
    else
      flash.now[:danger] = '編集に失敗しました'
      render action: :edit
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :content, category_ids: [])
  end

  def set_question
    @question = current_user.questions.find(params[:id])
  end

  def set_answer
    @answer = current_user.answers.new if current_user
  end
end
