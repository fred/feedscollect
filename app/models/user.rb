class User < ActiveRecord::Base
  class DestroyDenied
  end
  
  has_many :feed_sites
  
  acts_as_authentic
  
  # acts_as_authentic do |c|
  #   c.validates_length_of_login_field_options = {:within => 4..40}
  # end
  
  before_destroy :keep_admin
  
  def self.current_user
    session = UserSession.find
    if session
      @current_user = session.user
    else
      @current_user = nil
    end
    @current_user
  end
  
  def admin?
    self.admin
  end
  
  def self.admin_count
    count(:conditions => ["admin = ?",true])
  end
  
  private
  
  def keep_admin
    if self.admin? && User.admin_count < 2
      #raise ActiveRecord::ActiveRecordError
      raise Exceptions::DestroyDenied
    end
  end
  
  
end
