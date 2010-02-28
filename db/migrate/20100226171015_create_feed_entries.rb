class CreateFeedEntries < ActiveRecord::Migration
  def self.up
    create_table :feed_entries do |t|
      t.string  :title
      t.string  :url
      t.string  :author
      t.string  :summary
      t.string  :content
      t.datetime  :published
      t.integer :feed_site_id
      t.timestamps
    end
  end

  def self.down
    drop_table :feed_entries
  end
end
