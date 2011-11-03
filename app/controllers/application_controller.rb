# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery

  before_filter :set_globals
    
  def set_globals
    @start_time = Time.now.usec
    if current_user
      @global_user_id = current_user.id
      @site_categories = current_user.categories
      @feeds_per_page = current_user.feeds_per_page if current_user.feeds_per_page
    else
      @global_user_id = 0
      @site_categories = Category.general
      @feeds_per_page = FeedEntry.default_per_box
    end
  end
    
  def logged_in?
    current_user
  end
  
  def authorized?
    logged_in? # && current_user.admin?
  end
  
  def authorized_only
    redirect_to new_user_session_path unless authorized?
  end
  
  ##################
  # LOCALE METHODS #
  ##################
  
  def default_language
    "en"
  end
  
  def get_locale_from_profile
    if current_user && current_user.default_language
      case current_user.default_language
      when "Portugues"
        session[:language] = "pt-BR"
      when "English"
        session[:language] = "en"
      else
        session[:language] = "en"
      end
      logger.debug "* Lang from user profile : #{current_user.default_language}"
    end
  end
  
  # retrieve the language from the session store, 
  # otherwise set to default of pt-BR
  def get_locale_from_session
    if (session && session[:language])
      lang = session[:language]
    else
      lang = default_language
    end
    lang
  end
  
  # overwrite session language if params[:language] is given and fixate it
  # params[:session] only accepts 'en' or 'th' (English or Thai)
  # otherwise get from user profile
  def get_locale
    if (params[:language] && params[:language].to_s.match(/en|pt-BR/))
      logger.debug "* Lang from headers : #{extract_locale_from_accept_language_header}"
      logger.debug "* session[:language] was: '#{session[:language]}'"
      session[:language] = params[:language]
    elsif Rails.env == "test"
      session[:language] = "en"
    else
      session[:language] = get_locale_from_session
    end
    set_locale
  end
  
  def set_locale
    if session[:language]
      set_locale_to(session[:language])
    else
      lang = extract_locale_from_accept_language_header
      set_locale_to(default_language)
    end
  end
  
  def set_locale_to(lang)
    logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    I18n.locale = lang
    logger.debug "* Locale set to '#{I18n.locale}'"
    logger.debug "* session[:language] is '#{session[:language]}'"
  end
  
  
  
  private
    # def current_user_session
    #   return @current_user_session if defined?(@current_user_session)
    #   @current_user_session = UserSession.find
    # end
    # 
    # def current_user
    #   return @current_user if defined?(@current_user)
    #   @current_user = current_user_session && current_user_session.record
    # end
    
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to root_path
        return false
      end
    end
    
    def store_location
      if params[:return_to]
        session[:return_to] = params[:return_to]
      else
        session[:return_to] = request.url
      end
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  
end
