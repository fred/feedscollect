class FeedEntriesController < ApplicationController
  
  before_filter :require_user, :only => [:destroy]
  
  # GET /feed_entries
  # GET /feed_entries.xml
  def index
    @feed_entries = FeedEntry.all
    @title = "Feeds List"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @feed_entries }
    end
  end

  # GET /feed_entries/1
  # GET /feed_entries/1.xml
  def show
    @feed_entry = FeedEntry.find(params[:id])
    @feed_entry.set_read
    @title = @feed_entry.title
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feed_entry }
    end
  end
  
  def destroy
    @feed_entry = FeedEntry.find(params[:id])
    @feed_site = @feed_entry.feed_site
    if @feed_site.user_id == current_user.id
      @feed_entry.destroy
      flash[:notice] = "Successfully destroyed entry."
    end
    redirect_to @feed_site
  end

end
