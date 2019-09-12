class Blog::PostsController < ApplicationController
  before_action :authenticate_member!, :require_admin, except: [:index, :show], unless: :blogger_signed_in?
  before_action :authenticate_blogger!, except: [:index, :show], unless: :member_signed_in?
  before_action :find_post, except: [:index, :new, :create]

  def index
    if blogger_signed_in? || member_signed_in?
      @posts = Post.unscoped.order(created_at: :desc).page(params[:page])
    else
      @posts = Post.order(created_at: :desc).page(params[:page])
    end
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_auth_resource.posts.build(post_params)

    if @post.save
      redirect_to blog_post_page_path(@post)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @post.assign_attributes(post_params)
    if @post.save
      redirect_to blog_post_page_path(@post), notice: 'Post updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to :blog_posts_index, notice: 'Post deleted successfully'
  end

  private
    def post_params
      params.require(:post).permit(:title, :description, :meta_description, :content, :author, :image, :published)
    end

    def find_post
      @post = Post.unscoped.find(params[:id])
    end
end
