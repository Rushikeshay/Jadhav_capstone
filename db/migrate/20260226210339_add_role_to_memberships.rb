class AddRoleToMemberships < ActiveRecord::Migration[8.0]
  def change
    add_column :memberships, :role, :string, default: "owner"
  end
end
