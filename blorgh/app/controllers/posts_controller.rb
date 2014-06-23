class PostsController < ApplicationController
  def index
    @posts = Post.scoped_to(current_account)
  end

  def show
    @post = Post.find(params[:id])
  end
end
