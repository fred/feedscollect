class CategoriesController < ApplicationController

  before_filter :require_user, :only => [:new, :edit, :create, :update, :destroy]

  def index
    if logged_in? 
      @categories = current_user.own_categories
    else
      @categories = []
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  def show
    @category = Category.find(params[:id])
    @feed_sites = @category.feed_sites
    session[:last_category] = @category.id
    if @category.description.present?
      @title = @category.description
    else
      @title = @category.title
    end
    headers['Cache-Control'] = "public, max-age=600"
    respond_to do |format|
      format.html
      format.xml  { render :xml => @category }
    end
  end

  def home
    home_page_category_id = nil
    home_page_category_id = session[:last_category] if session[:last_category]
    home_page_category_id = current_user.home_page_category_id if current_user
    @category = Category.default_category(home_page_category_id)
    params[:id] = @category.id
    @feed_sites = @category.feed_sites(:include => :feed_entries)
    if @category.description.to_s.blank?
      @title = @category.title
    else
      @title = @category.description
    end
    render :action => "show"
  end

  def new
    @category = Category.new
    @title = "New Category"

    respond_to do |format|
      format.html
      format.xml  { render :xml => @category }
    end
  end

  def edit
    @category = Category.find(params[:id], :conditions => ["owner_id = ?", current_user.id])
    @title = "Edit Category: #{@category.title}"
  end

  def create
    @category = Category.new(params[:category])
    @title = "New Category"
    @category.owner_id = current_user.id
    
    respond_to do |format|
      if @category.save
        current_user.categories << @category
        flash[:notice] = 'Category was successfully created.'
        format.html { redirect_to(categories_url) }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @category = Category.find(params[:id], :conditions => ["owner_id = ?", current_user.id])
    @category.owner_id = current_user.id
    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to(categories_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @category = Category.find(params[:id], :conditions => ["owner_id = ?", current_user.id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(categories_url) }
      format.xml  { head :ok }
    end
  end

end
