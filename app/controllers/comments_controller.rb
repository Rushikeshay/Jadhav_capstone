class CommentsController < ApplicationController
  def create
    the_comment = Comment.new
    the_comment.user_id = current_user.id
    the_comment.activity_id = params.fetch("query_activity_id")
    the_comment.body = params.fetch("query_body")

    the_comment.save
    redirect_back fallback_location: "/trips"
  end

  def destroy
    the_id = params.fetch("path_id")
    the_comment = Comment.find_by(id: the_id, user_id: current_user.id)
    the_comment&.destroy
    redirect_back fallback_location: "/trips"
  end
end
