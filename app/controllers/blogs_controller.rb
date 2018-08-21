class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:new, :edit, :show, :destroy]

  def top
    render 'top'
  end

  def index
    @blogs = Blog.order(:created_at)
  end

  def new
    if params[:back]
      # テーブルの中に、imageのカラム（画像アップロード用のカラム）以外のものがある場合、
      # new(xxxx_params)にする。
      @blog = Blog.new(blog_params)
      # 画像保存（create）の際に、キャッシュから画像を復元してnewに入れる
      # newに戻る際も、createと同様に復元処理が必要となる。
      unless params[:cache][:image].empty?
        @blog.image.retrieve_from_cache! params[:cache][:image]
      end
    else
      @blog = Blog.new
      @blog.user_id = current_user.id
    end
  end

  def confirm
    @blog = Blog.new(blog_params)
    render 'new' if @blog.invalid?
  end

  def create
    # テーブルの中に、imageのカラム（画像アップロード用のカラム）以外のものがある場合、
    # new(xxxx_params)にする。
    @blog = Blog.new(blog_params)
    # 画像保存（create）の際に、キャッシュから画像を復元してnewに入れる
    unless params[:cache][:image].empty?
      @blog.image.retrieve_from_cache! params[:cache][:image]
    end
    if @blog.save
      NotifyMailer.notify_mail(current_user).deliver
      redirect_to blogs_path, notice: "ブログを作成しました！"
    else
      render 'new'
    end
  end

  def show
    @favorite = current_user.favorites.find_by(blog_id: @blog.id)
    @comment = @blog.comments.build
    @comments = @blog.comments
  end

  def edit
  end

  def update
    if @blog.update(blog_params)
      redirect_to blogs_path, notice: "ブログを編集しました！"
    else
      render 'edit'
    end
  end

  def destroy
    @blog.destroy
    redirect_to blogs_path, notice: "ブログを削除しました！"
  end

  private
  def blog_params
    params.require(:blog).permit(:title, :content, :user_id, :image, :image_cache)
  end

  def set_blog
    @blog = Blog.find(params[:id])
  end

  def logged_in_user
    redirect_to new_session_path unless logged_in?
  end
end
