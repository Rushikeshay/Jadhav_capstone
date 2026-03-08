class ActivitiesController < ApplicationController
  def index
    # Only show activities belonging to the current user's trips
    @list_of_activities = Activity.joins(day: :trip)
                                  .where(trips: { id: current_user.trip_ids })
                                  .order({ :created_at => :desc })

    render({ :template => "activity_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")
    @the_activity = Activity.where({ :id => the_id }).at(0)
    render({ :template => "activity_templates/show" })
  end

  def create
    the_activity = Activity.new
    the_activity.day_id = params.fetch("query_day_id")
    the_activity.name = params.fetch("query_name")
    the_activity.address = params["query_address"]
    the_activity.notes = params["query_notes"]
    the_activity.any_cost = params["query_any_cost"]

    if params.has_key?("query_picture")
      the_activity.picture = params.fetch("query_picture")
    end

    if the_activity.valid?
      the_activity.save
      redirect_to("/days/#{the_activity.day_id}", { :notice => "Activity created successfully." })
    else
      redirect_to("/days/#{the_activity.day_id}", { :alert => the_activity.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_activity = Activity.where({ :id => the_id }).at(0)
    trip_id = the_activity.day.trip_id

    unless Membership.exists?(user_id: current_user.id, trip_id: trip_id, role: "owner")
      redirect_to("/days/#{the_activity.day_id}", { :alert => "You don't have permission to edit that activity." }) and return
    end

    the_activity.name = params.fetch("query_name")
    the_activity.picture = params.fetch("query_picture", the_activity.picture)
    the_activity.picture_caption = params.fetch("query_picture_caption", the_activity.picture_caption)
    the_activity.address = params.fetch("query_address")
    the_activity.notes = params.fetch("query_notes")
    the_activity.any_cost = params.fetch("query_any_cost")
    the_activity.cost = params.fetch("query_cost")
    the_activity.day_id = params.fetch("query_day_id")

    if the_activity.valid?
      the_activity.save
      redirect_to("/activities/#{the_activity.id}", { :notice => "Activity updated successfully." })
    else
      redirect_to("/activities/#{the_activity.id}", { :alert => the_activity.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_activity = Activity.where({ :id => the_id }).at(0)
    day_id = the_activity.day_id
    trip_id = the_activity.day.trip_id

    unless Membership.exists?(user_id: current_user.id, trip_id: trip_id, role: "owner")
      redirect_to("/days/#{day_id}", { :alert => "You don't have permission to delete that activity." }) and return
    end

    the_activity.destroy
    redirect_to("/days/#{day_id}", { :notice => "Activity deleted successfully." })
  end
end
