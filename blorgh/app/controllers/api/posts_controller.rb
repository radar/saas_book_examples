class Api::PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      render :show, :status => 201
    else
      render "api/shared/errors", resource: @post, status: 422
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      render :show
    else
      render "api/shared/errors", resource: @post, status: 422
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    render nothing: true
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
