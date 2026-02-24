class AddCoordinatesToActivities < ActiveRecord::Migration[8.0]
  def change
    add_column :activities, :latitude, :float unless column_exists?(:activities, :latitude)
    add_column :activities, :longitude, :float unless column_exists?(:activities, :longitude)
  end
end
