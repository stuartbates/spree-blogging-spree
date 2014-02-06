class AddDefaultValueToViewCountOnSpreeBlogEntries < ActiveRecord::Migration
  def up
    change_column :spree_blog_entries, :view_count, :integer, :default => 0, :null => false
  end

  def down
    change_column :spree_blog_entries, :view_count, :integer
  end
end