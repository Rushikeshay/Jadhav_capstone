module ApplicationHelper
  # Builds the JSON array of map markers for the Google Maps Stimulus controller.
  # Only includes activities that have been geocoded (lat/lng present).
  def map_markers_json(activities)
    markers = activities.select { |a| a.latitude.present? && a.longitude.present? }
                        .map { |a| { title: a.name, lat: a.latitude, lng: a.longitude } }
    markers.to_json
  end
end
