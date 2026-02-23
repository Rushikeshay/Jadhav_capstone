class CreateDays < ActiveRecord::Migration[8.0]
  def change
    create_table :days do |t|
      t.date :date
      t.integer :trip_id

      t.timestamps
    end
  end
end
