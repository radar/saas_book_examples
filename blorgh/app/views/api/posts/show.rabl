object @post
attributes :id, :title, :text
child(@post.comments => :comments) do
  attributes :id, :username, :text
end