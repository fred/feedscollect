class FeedSitesController < ApplicationController
  
  before_filter :require_user, :only => [:new, :edit, :create, :update, :destroy]
  
  def index
    own_categories = current_user.own_category_ids
    @feed_sites = FeedSite.find(:all, :conditions => ["category_id in (#{own_categories.join(',')})"], :order => "title ASC")
    @title = "Feed Sites list"
  end
  
  def show
    @feed_site = current_user.feed_sites.find(params[:id])
    @title = @feed_site.title
  end
  
  def new
    @feed_site = FeedSite.new
    @feed_site.user_id = current_user.id
    @title = "New Feed Site"
  end
  
  def create
    @feed_site = FeedSite.new(params[:feed_site])
    @feed_site.user_id = current_user.id
    if @feed_site.save
      flash[:notice] = "Successfully created feed site."
      redirect_to @feed_site
    else
      render :action => 'new'
    end
  end
  
  def edit
    @feed_site = current_user.feed_sites.find(params[:id])
    @title = "Edit #{@feed_site.title}"
  end
  
  def update
    @feed_site = current_user.feed_sites.find(params[:id])
    @feed_site.user_id = current_user.id
    if @feed_site.update_attributes(params[:feed_site])
      flash[:notice] = "Successfully updated feed site."
      redirect_to @feed_site
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @feed_site = current_user.feed_sites.find(params[:id])
    @feed_site.destroy
    flash[:notice] = "Successfully destroyed feed site."
    redirect_to feed_sites_url
  end
  
  def refresh_xluriwaplezx
    FeedSite.refresh
    flash[:notice] = "Refreshing all feeds now..."
    redirect_to :action => "index"
  end
  
end
