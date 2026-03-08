class UsersController < ApplicationController
  def show
    @the_user = User.find(params[:path_id])
    @user_activities = Activity.joins(day: :trip)
                               .where(trips: { id: @the_user.trip_ids })
                               .includes(:likes, :comments, day: :trip)
                               .order(created_at: :desc)
    @followers = @the_user.followers
    @is_own_profile = (current_user.id == @the_user.id)
    @my_follow = current_user.follow_relationships.find_by(followed_id: @the_user.id)
    @user_journals = @is_own_profile ? current_user.journals.includes(day: :trip).order(created_at: :desc) : []
    @user_trips = @the_user.trips.order(created_at: :desc)
    render template: "user_templates/show"
  end

  def update_avatar
    if params[:query_avatar].present?
      current_user.avatar = params[:query_avatar]
      current_user.save
    end
    redirect_to "/profiles/#{current_user.id}", notice: "Profile picture updated."
  end
end
