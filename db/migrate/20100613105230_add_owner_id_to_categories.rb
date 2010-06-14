class AddOwnerIdToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :owner_id, :integer
  end

  def self.down
    remove_column :categories, :owner_id, :integer
  end
end
