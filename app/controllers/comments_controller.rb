class CommentsController < ApplicationController
  prepend_before_action :set_commentable
  before_action :authenticate_user!

  def create
    @comment = @commentable.comments.build(comment_params)
    if @comment.save
      flash[:success] = 'コメントしました'
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = '失敗しました'
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @comment = @commentable.comments.find(params[:id])
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
    params.require(:comment).permit(:content, :user_id)
  end
end
