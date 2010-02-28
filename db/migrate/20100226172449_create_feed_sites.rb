class CreateFeedSites < ActiveRecord::Migration
  def self.up
    create_table :feed_sites do |t|
      t.string  :title
      t.string  :url
      t.string  :etag
      t.text    :description
      t.integer :category_id
      t.integer :feed_type
      t.datetime  :last_modified
      t.timestamps
    end
  end
  
  def self.down
    drop_table :feed_sites
  end
end
