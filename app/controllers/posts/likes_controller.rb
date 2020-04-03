class Posts::LikesController < LikesController
  private

  def set_likable
    @likable = Post.find(params[:post_id])
  end
end
