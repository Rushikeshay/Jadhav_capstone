class LikesController < ApplicationController
  def create
    activity_id = params.fetch("query_activity_id")
    existing = Like.find_by(user_id: current_user.id, activity_id: activity_id)
    unless existing
      Like.create(user_id: current_user.id, activity_id: activity_id)
    end
    redirect_back fallback_location: "/trips"
  end

  def destroy
    the_id = params.fetch("path_id")
    the_like = Like.find_by(id: the_id, user_id: current_user.id)
    the_like&.destroy
    redirect_back fallback_location: "/trips"
  end
end
