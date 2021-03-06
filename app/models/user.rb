class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :full_name, :feeds_per_page, :font_size
  
  
  has_and_belongs_to_many :categories
  has_many :feed_sites
  has_many :own_categories, :class_name => "Category", :foreign_key => "owner_id"
  
  has_and_belongs_to_many :roles
  
  def has_role?(role)
    self.roles.where(:title => role.to_s.downcase).count > 0
  end
  
  def role_titles
    self.roles.collect {|t| t.title}.join(", ")
  end
  
  def role_models
    rol = []
    self.roles.collect.each do |t|
      rol << t.title.capitalize
    end
    rol
  end

  def is_admin?
    type == "AdminUser"
  end

end
