class AddTitleToDays < ActiveRecord::Migration[8.0]
  def change
    add_column :days, :title, :string
  end
end
