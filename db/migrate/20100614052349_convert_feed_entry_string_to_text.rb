class ConvertFeedEntryStringToText < ActiveRecord::Migration
  def self.up
    change_column :feed_entries, :summary, :text
    change_column :feed_entries, :content, :text
  end

  def self.down
    change_column :feed_entries, :summary, :string
    change_column :feed_entries, :content, :string
  end
end
