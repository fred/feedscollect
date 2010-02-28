class ChangeDefaultCategory < ActiveRecord::Migration
  def self.up
    remove_column :categories, :default_home
    add_column :categories, :default_home, :boolean, :default => false
  end

  def self.down
    remove_column :categories, :default_home
    add_column :categories, :default_home, :boolean, :default => true
  end
end
