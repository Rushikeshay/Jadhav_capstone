class TripsController < ApplicationController
  def index
    @my_trips = current_user.trips.order({ :created_at => :desc })

    followed_ids = current_user.following.pluck(:id)
    if followed_ids.any?
      owner_memberships = Membership.where({ :user_id => followed_ids, :role => "owner" })
      owner_trip_ids = owner_memberships.pluck(:trip_id)
      day_ids = Day.where({ :trip_id => owner_trip_ids }).pluck(:id)

      @feed_activities = Activity.where({ :day_id => day_ids })
                                 .includes({ :day => :trip }, { :likes => :user }, { :comments => :user })
                                 .order({ :created_at => :desc })
                                 .limit(30)

      # Build trip_id => owner User lookup for display in feed
      user_ids = owner_memberships.pluck(:user_id)
      users_by_id = User.where({ :id => user_ids }).index_by(&:id)
      @trip_owners = {}
      owner_memberships.each { |m| @trip_owners[m.trip_id] = users_by_id[m.user_id] }
    else
      @feed_activities = []
      @trip_owners = {}
    end

    render({ :template => "trip_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_trips = Trip.where({ :id => the_id })

    @the_trip = matching_trips.at(0)

    render({ :template => "trip_templates/show" })
  end

  def create
    the_trip = Trip.new
    the_trip.title = params.fetch("query_title")
    the_trip.cover_image = params[:cover_image] if params[:cover_image].present?

    if the_trip.valid?
      the_trip.save
      Membership.create({ :user_id => current_user.id, :trip_id => the_trip.id, :role => "owner" })
      redirect_to("/trips", { :notice => "Trip created successfully." })
    else
      redirect_to("/trips", { :alert => the_trip.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_trip = Trip.where({ :id => the_id }).at(0)

    the_trip.title = params.fetch("query_title")
    the_trip.cover_image = params[:cover_image] if params[:cover_image].present?

    if the_trip.valid?
      the_trip.save
      redirect_to("/trips/#{the_trip.id}", { :notice => "Trip updated successfully." })
    else
      redirect_to("/trips/#{the_trip.id}", { :alert => the_trip.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_trip = Trip.where({ :id => the_id }).at(0)

    the_trip.destroy

    redirect_to("/trips", { :notice => "Trip deleted successfully." })
  end
end
