class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :destroy]
  before_action :set_user, only: [:index, :create]
  before_action :set_post, only: [:edit, :update, :destroy]
  def index
    @posts = @user.posts
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = current_user.posts.new(post_params)
    @post.set_taggable
    if @post.save
      flash[:success] = '投稿に成功しました'
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = '投稿に失敗しました'
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    if @post.update(post_params)
      @post.set_taggable
      redirect_to user_posts_path(current_user.id), flash: { success: '編集しました' }
    else
      flash[:danger] = '編集に失敗しました'
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @post.destroy
    redirect_to user_posts_path(current_user.id), flash: { success: '削除しました' }
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def post_params
    params.require(:post).permit(:content, category_ids: [])
  end

  def set_post
    @post = current_user.posts.find(params[:id])
  end
end
