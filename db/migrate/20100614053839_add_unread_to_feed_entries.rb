class AddUnreadToFeedEntries < ActiveRecord::Migration
  def self.up
    add_column :feed_entries, :unread, :boolean, :default => true
  end

  def self.down
    remove_column :feed_entries, :unread
  end
end
