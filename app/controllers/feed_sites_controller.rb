class FeedSitesController < ApplicationController
  
  def index
    @feed_sites = FeedSite.all(:order => "title ASC")
    @title = "Feed Sites list"
  end
  
  def show
    @feed_site = FeedSite.find(params[:id])
    @title = @feed_site.title
  end
  
  def refresh_xluriwaplezx
    FeedSite.refresh
    flash[:notice] = "Refreshing all feeds now..."
    redirect_to :action => "index"
  end
  
end
