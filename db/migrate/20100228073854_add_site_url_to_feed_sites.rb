class AddSiteUrlToFeedSites < ActiveRecord::Migration
  def self.up
    add_column :feed_sites, :site_url, :string
    add_column :feed_sites, :logo_url, :string
    add_column :feed_sites, :sort_order, :string
  end

  def self.down
    remove_column :feed_sites, :site_url
    remove_column :feed_sites, :logo_url
    remove_column :feed_sites, :sort_order
  end
end
