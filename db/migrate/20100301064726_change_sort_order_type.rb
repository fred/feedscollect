class ChangeSortOrderType < ActiveRecord::Migration
  def self.up
    change_column(:feed_sites, :sort_order, :integer, :default => 200)
  end

  def self.down
    change_column(:feed_sites, :sort_order, :string, :default => 200)
  end
end
