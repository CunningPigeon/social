class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET 
  def index
    @post = Post.all
  end

  # GET 
  def show
  end

  # GET 
  def new
    @user = current_user
    @post = @user.posts.build
  end

  # GET 
  def edit
  end

  # POST 
  def create
    @user = current_user
    if @user.nil?
      redirect_to new_user_session_path, alert: "Пожалуйста, войдите в систему."
      return
    end
    @post = @user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to profile_path(@user), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT 
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to profile_path(current_user), notice: "Пост успешно обновлен." }
        format.json { render :profile_path, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE 
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to profile_path(current_user), notice: "Пост успешно удален." }
      format.json { head :no_content }
    end
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content, :hashtags, :user_id)
    end
end
