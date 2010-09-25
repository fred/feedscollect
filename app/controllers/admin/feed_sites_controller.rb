class Admin::FeedSitesController < Admin::BaseController
  
  def index
    
    if params[:category_id]
      @category = Category.find(params[:category_id])
      @feed_sites = @category.feed_sites
    else
      @feed_sites = FeedSite.all(:order => "category_id ASC, sort_order ASC, title ASC")
    end
    
    @title = "Feed Sites list"
  end
  
  def show
    @feed_site = FeedSite.find(params[:id])
    @title = @feed_site.title
  end
  
  def new
    @feed_site = FeedSite.new
    @title = "New Feed Site"
  end
  
  def create
    @feed_site = FeedSite.new(params[:feed_site])
    if @feed_site.save
      flash[:notice] = "Successfully created feed site."
      redirect_to admin_feed_site_path(@feed_site)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @feed_site = FeedSite.find(params[:id])
    @title = "Edit #{@feed_site.title}"
  end
  
  def update
    @feed_site = FeedSite.find(params[:id])
    if @feed_site.update_attributes(params[:feed_site])
      flash[:notice] = "Successfully updated feed site."
      redirect_to admin_feed_site_path(@feed_site)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @feed_site = FeedSite.find(params[:id])
    @feed_site.destroy
    flash[:notice] = "Successfully destroyed feed site."
    redirect_to admin_feed_sites_url
  end
end
