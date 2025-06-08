class AddRolesToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :student, :boolean, default: true
    add_column :users, :instructor, :boolean, default: false
    add_column :users, :admin, :boolean, default: false
  end
end
