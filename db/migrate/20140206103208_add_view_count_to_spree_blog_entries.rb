class AddViewCountToSpreeBlogEntries < ActiveRecord::Migration
  def change
    add_column :spree_blog_entries, :view_count, :integer
  end
end
