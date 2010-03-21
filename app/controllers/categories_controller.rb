class CategoriesController < ApplicationController
  
  # GET /categories
  # GET /categories.xml
  def index
    @categories = Category.all
    @title = "Categories List"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.find(params[:id])
    @feed_sites = @category.feed_sites
    session[:last_category] = @category.id
    
    if @category.description.to_s.blank?
      @title = @category.title
    else
      @title = @category.description
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
      format.iphone
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

end
