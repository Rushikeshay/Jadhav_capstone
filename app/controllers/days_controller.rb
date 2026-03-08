class DaysController < ApplicationController
  def index
    # Only show days belonging to the current user's trips
    @list_of_days = Day.joins(:trip)
                       .where(trips: { id: current_user.trip_ids })
                       .order({ :created_at => :desc })

    render({ :template => "day_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")
    @the_day = Day.where({ :id => the_id }).at(0)
    render({ :template => "day_templates/show" })
  end

  def create
    the_day = Day.new
    the_day.date = params.fetch("query_date")
    the_day.title = params.fetch("query_title", "")
    the_day.trip_id = params.fetch("query_trip_id")

    if the_day.valid?
      the_day.save
      redirect_to("/days/#{the_day.id}", { :notice => "Day created successfully." })
    else
      redirect_to("/trips/#{params.fetch("query_trip_id")}", { :alert => the_day.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_day = Day.where({ :id => the_id }).at(0)

    unless Membership.exists?(user_id: current_user.id, trip_id: the_day.trip_id, role: "owner")
      redirect_to("/trips/#{the_day.trip_id}", { :alert => "You don't have permission to edit that day." }) and return
    end

    the_day.date = params.fetch("query_date")
    the_day.title = params.fetch("query_title", "")
    the_day.trip_id = params.fetch("query_trip_id")
    the_day.cover_image = params[:query_cover_image] if params[:query_cover_image].present?

    if the_day.valid?
      the_day.save
      redirect_to("/days/#{the_day.id}", { :notice => "Day updated successfully." })
    else
      redirect_to("/days/#{the_day.id}", { :alert => the_day.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_day = Day.where({ :id => the_id }).at(0)
    trip_id = the_day.trip_id

    unless Membership.exists?(user_id: current_user.id, trip_id: trip_id, role: "owner")
      redirect_to("/trips/#{trip_id}", { :alert => "You don't have permission to delete that day." }) and return
    end

    the_day.destroy
    redirect_to("/trips/#{trip_id}", { :notice => "Day deleted successfully." })
  end
end
