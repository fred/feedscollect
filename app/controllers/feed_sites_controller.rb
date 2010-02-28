class FeedSitesController < ApplicationController
  
  def index
    @feed_sites = FeedSite.all(:order => "title ASC")
    @title = "Feed Sites list"
  end
  
  def show
    @feed_site = FeedSite.find(params[:id])
    @title = @feed_site.title
  end
  
end
