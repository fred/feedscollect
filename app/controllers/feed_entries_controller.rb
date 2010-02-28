class FeedEntriesController < ApplicationController
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
    @title = @feed_entry.title
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feed_entry }
    end
  end

end
