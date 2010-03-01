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

    if @category.description.to_s.blank?
      @title = @category.title
    else
      @title = @category.description
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
    end
  end
  
  
  def home
    @category = Category.default_category
    if @category.nil?
      @category = Category.find(:first)
    end
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
