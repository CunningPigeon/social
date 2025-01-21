class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: %i[destroy ]


  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user 

    if @comment.save
      redirect_to user_path(@post), notice: 'Комментарий успешно добавлен.'
    else
      render 'posts/show', alert: 'Не удалось добавить комментарий.'
    end
  end

  def destroy
    @comment.destroy
    redirect_to user_path(params[:id]), notice: 'Комментарий был удалён.'
  end

  private

    def set_comment
      @comment = @post.comments.find(params[:id])
    end

    def set_post
      @post = Post.find(params[:post_id]) # Получаем пост по ID
    end

    def set_user
      @user = User.find(params[:id]) 
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end
