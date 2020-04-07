class CommentsController < ApplicationController
  prepend_before_action :set_commentable, only: :create
  before_action :authenticate_user!

  def create
    @comment = @commentable.comments.build(comment_params)
    if @comment.save
      @commentable.create_notification_comment(current_user, @comment)
      flash[:success] = 'コメントしました'
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = '失敗しました'
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    if @comment.destroy
      flash[:success] = 'コメントを削除しました'
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = '失敗しました'
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content).merge!(user_id: current_user.id)
  end
end
