class AddUserIdToFeedSites < ActiveRecord::Migration
  def self.up
    add_column :feed_sites, :user_id, :integer
  end

  def self.down
    remove_column :feed_sites, :user_id
  end
end
