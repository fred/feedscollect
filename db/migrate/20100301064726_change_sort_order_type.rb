class ChangeSortOrderType < ActiveRecord::Migration
  def self.up
    remove_column :feed_sites, :sort_order
    add_column    :feed_sites, :sort_order, :integer, :default => 200
  end

  def self.down
    remove_column :feed_sites, :sort_order
    add_column    :feed_sites, :sort_order, :string
  end
end
