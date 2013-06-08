ActiveAdmin.register FeedEntry do
  index do
    column :id
    column :title
    column :feed_site
    column :url do |entry|
      link_to(entry.url.to_s.truncate(30), entry.url) if entry.url
    end
    column :author
    column :summary do |entry|
      sanitize(entry.summary.to_s).truncate(60) if entry.summary
    end
    column :published
    column :updated_at
    column :created_at
    default_actions
  end
  
end
