class AddDefaultToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :default_home, :boolean, :default => true
    add_column :categories, :permalink, :string
  end

  def self.down
    remove_column :categories, :permalink
    remove_column :categories, :default_home
  end
end
