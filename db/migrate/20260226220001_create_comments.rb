class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.integer :user_id, null: false
      t.integer :activity_id, null: false
      t.text :body, null: false
      t.timestamps
    end
  end
end
