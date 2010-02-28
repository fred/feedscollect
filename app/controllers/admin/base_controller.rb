class Admin::BaseController < ApplicationController

  before_filter :authorized_only
  
  before_filter :set_per_page
  
  layout 'admin'
  
  protected
  
  
  def set_per_page
    if session[:per_page]
      @per_page = session[:per_page]
    else
      @per_page = 25 # Default to 25
    end
    
    if params[:per_page]
      session[:per_page] = params[:per_page]
      @per_page = session[:per_page]
    end
    
  end
    
  # check the roles of current user
  def check_admin
    if current_user.has_role? "admin"
      logger.info " *** Allowed for #{current_user.login}"
      true
    else
      logger.info " *** Denied for #{current_user.login}"
      flash[:error] = "Access Denied"
      redirect_to "/"
    end
  end
  
  
  private
  
    def last_modified_header
      headers["last_modified"] = last_modified
    end
  
    def set_user_time_zone
      Time.zone = current_user.time_zone if logged_in?
    end
    
    def extract_locale_from_accept_language_header
      # if request.env['HTTP_ACCEPT_LANGUAGE'] && !request.env['HTTP_ACCEPT_LANGUAGE'].empty?
      #   lang = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
      #   lang = "th" if lang.empty?
      # end
      # Should work for all browsers
      lang = "th"
      return lang
    end
        
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
        
end
