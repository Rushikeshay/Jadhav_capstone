class CreateActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :activities do |t|
      t.string :name
      t.string :picture
      t.string :address
      t.string :notes
      t.boolean :any_cost
      t.integer :cost
      t.string :picture_caption
      t.integer :day_id

      t.timestamps
    end
  end
end
