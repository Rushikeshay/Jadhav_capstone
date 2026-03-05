class AddCoverImageToDay < ActiveRecord::Migration[8.0]
  def change
    add_column :days, :cover_image, :string
  end
end
