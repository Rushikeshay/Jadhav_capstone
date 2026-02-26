class AddCoverImageToTrips < ActiveRecord::Migration[8.0]
  def change
    add_column :trips, :cover_image, :string
  end
end
