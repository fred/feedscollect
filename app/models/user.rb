class User < ActiveRecord::Base
  class DestroyDenied
  end
  
  acts_as_authentic
  
  before_destroy :keep_admin
    
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
