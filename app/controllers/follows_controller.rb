class FollowsController < ApplicationController
  def index
    @list_of_users = User.where.not(id: current_user.id).order(:first_name, :last_name)
    @following_ids = current_user.following.pluck(:id)
    # Map followed_user_id -> follow record id for unfollow links
    @follow_map = current_user.follow_relationships.pluck(:followed_id, :id).to_h
    render({ :template => "follow_templates/index" })
  end

  def create
    the_follow = Follow.new
    the_follow.follower_id = current_user.id
    the_follow.followed_id = params.fetch("query_followed_id")

    if the_follow.save
      redirect_back(fallback_location: "/people", notice: "Now following!")
    else
      redirect_back(fallback_location: "/people", alert: the_follow.errors.full_messages.to_sentence)
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_follow = Follow.where({ :id => the_id, :follower_id => current_user.id }).at(0)

    if the_follow
      the_follow.destroy
      redirect_back(fallback_location: "/people", notice: "Unfollowed.")
    else
      redirect_to("/people", { :alert => "Follow not found." })
    end
  end
end

