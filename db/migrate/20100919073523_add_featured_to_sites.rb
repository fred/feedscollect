class AddFeaturedToSites < ActiveRecord::Migration
  def self.up
    add_column :feed_sites, :featured, :boolean, :default => false
  end

  def self.down
    remove_column :feed_sites, :featured
  end
end
