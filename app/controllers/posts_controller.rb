class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  before_action :set_post, only: [:edit, :update, :destroy]

  def index
    @posts = Post.includes(:user, :tag_relationships, :categories, :likes).recent.page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.new(post_params)
    @post.set_taggable
    if @post.save
      flash[:success] = 'つぶやきました'
      redirect_to posts_path
    else
      flash.now[:danger] = 'つぶやきに失敗しました'
      render action: :new
    end
  end

  def update
    if @post.update(post_params)
      @post.set_taggable
      redirect_to posts_path, flash: { success: '編集しました' }
    else
      flash.now[:danger] = '編集に失敗しました'
      render action: :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, flash: { success: '削除しました' }
  end

  private

  def post_params
    params.require(:post).permit(:content, category_ids: [])
  end

  def set_post
    @post = current_user.posts.find(params[:id])
  end
end
