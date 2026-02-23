class ActivitiesController < ApplicationController
  def index
    matching_activities = Activity.all

    @list_of_activities = matching_activities.order({ :created_at => :desc })

    render({ :template => "activity_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_activities = Activity.where({ :id => the_id })

    @the_activity = matching_activities.at(0)

    render({ :template => "activity_templates/show" })
  end

  def create
    the_activity = Activity.new
    the_activity.name = params.fetch("query_name")
    the_activity.picture = params.fetch("query_picture")
    the_activity.address = params.fetch("query_address")
    the_activity.notes = params.fetch("query_notes")
    the_activity.any_cost = params.fetch("query_any_cost")
    the_activity.cost = params.fetch("query_cost")
    the_activity.picture_caption = params.fetch("query_picture_caption")
    the_activity.day_id = params.fetch("query_day_id")

    if the_activity.valid?
      the_activity.save
      redirect_to("/activities", { :notice => "Activity created successfully." })
    else
      redirect_to("/activities", { :alert => the_activity.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_activity = Activity.where({ :id => the_id }).at(0)

    the_activity.name = params.fetch("query_name")
    the_activity.picture = params.fetch("query_picture")
    the_activity.address = params.fetch("query_address")
    the_activity.notes = params.fetch("query_notes")
    the_activity.any_cost = params.fetch("query_any_cost")
    the_activity.cost = params.fetch("query_cost")
    the_activity.picture_caption = params.fetch("query_picture_caption")
    the_activity.day_id = params.fetch("query_day_id")

    if the_activity.valid?
      the_activity.save
      redirect_to("/activities/#{the_activity.id}", { :notice => "Activity updated successfully." } )
    else
      redirect_to("/activities/#{the_activity.id}", { :alert => the_activity.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_activity = Activity.where({ :id => the_id }).at(0)

    the_activity.destroy

    redirect_to("/activities", { :notice => "Activity deleted successfully." } )
  end
end
