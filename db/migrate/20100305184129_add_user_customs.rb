class AddUserCustoms < ActiveRecord::Migration
  def self.up
    add_column :users, :full_name, :string
    add_column :users, :feeds_per_page, :integer
    add_column :users, :font_size, :float, :default => 1.0
    add_column :users, :home_page_category_id, :integer
  end

  def self.down
    remove_column :users, :full_name
    remove_column :users, :feeds_per_page
    remove_column :users, :font_size
    remove_column :users, :home_page_category_id
  end
end
