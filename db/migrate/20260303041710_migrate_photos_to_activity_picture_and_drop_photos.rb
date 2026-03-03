class MigratePhotosToActivityPictureAndDropPhotos < ActiveRecord::Migration[8.0]
  def up
    # Copy first photo image to activity.picture for any activity that has photos but no picture
    execute <<-SQL
      UPDATE activities
      SET picture = (
        SELECT image FROM photos
        WHERE photos.activity_id = activities.id
        ORDER BY photos.id ASC
        LIMIT 1
      )
      WHERE picture IS NULL
        AND EXISTS (SELECT 1 FROM photos WHERE photos.activity_id = activities.id)
    SQL

    drop_table :photos
  end

  def down
    create_table :photos do |t|
      t.string :caption
      t.string :image
      t.integer :activity_id
      t.timestamps
    end
  end
end
