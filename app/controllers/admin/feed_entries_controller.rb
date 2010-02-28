class Admin::FeedEntriesController < Admin::BaseController
  
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

  # GET /feed_entries/new
  # GET /feed_entries/new.xml
  def new
    @feed_entry = FeedEntry.new
    @title = "New Feed Entry"
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @feed_entry }
    end
  end

  # GET /feed_entries/1/edit
  def edit
    @feed_entry = FeedEntry.find(params[:id])
    @title = "Edit Feed Entry: #{@feed_entry.title}"
  end

  # POST /feed_entries
  # POST /feed_entries.xml
  def create
    @feed_entry = FeedEntry.new(params[:feed_entry])

    respond_to do |format|
      if @feed_entry.save
        flash[:notice] = 'FeedEntry was successfully created.'
        format.html { redirect_to(admin_feed_entries_url) }
        format.xml  { render :xml => @feed_entry, :status => :created, :location => @feed_entry }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @feed_entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /feed_entries/1
  # PUT /feed_entries/1.xml
  def update
    @feed_entry = FeedEntry.find(params[:id])

    respond_to do |format|
      if @feed_entry.update_attributes(params[:feed_entry])
        flash[:notice] = 'FeedEntry was successfully updated.'
        format.html { redirect_to(admin_feed_entries_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feed_entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /feed_entries/1
  # DELETE /feed_entries/1.xml
  def destroy
    @feed_entry = FeedEntry.find(params[:id])
    @feed_entry.destroy

    respond_to do |format|
      format.html { redirect_to(admin_feed_entries_url) }
      format.xml  { head :ok }
    end
  end
end
