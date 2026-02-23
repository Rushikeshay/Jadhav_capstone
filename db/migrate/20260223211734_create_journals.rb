class CreateJournals < ActiveRecord::Migration[8.0]
  def change
    create_table :journals do |t|
      t.integer :day_id
      t.integer :user_id
      t.text :ai_generated_questions
      t.text :response
      t.integer :best_activity_id

      t.timestamps
    end
  end
end
