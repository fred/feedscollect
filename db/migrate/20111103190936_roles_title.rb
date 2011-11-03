class RolesTitle < ActiveRecord::Migration
  def up
    rename_column :roles, :name, :title
  end

  def down
    rename_column :roles, :title, :name
  end
end
