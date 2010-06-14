class CreateCategoriesUsers < ActiveRecord::Migration
  def self.up
    create_table :categories_users, :id => false do |t|
      t.references :category
      t.references :user
    end
  end

  def self.down
    drop_table :categories_users
  end
end
