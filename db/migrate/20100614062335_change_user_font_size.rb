class ChangeUserFontSize < ActiveRecord::Migration
  def self.up
    change_column :users, :font_size, :float, :default => 0.7
  end

  def self.down
    change_column :users, :font_size, :float, :default => 1.0
  end
end
