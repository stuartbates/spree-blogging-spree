class AddIndexToSpreeCategoryEntries < ActiveRecord::Migration
  def change
    add_index :spree_category_entries, :blog_entry_id
    add_index :spree_category_entries, :blog_category_id
  end
end