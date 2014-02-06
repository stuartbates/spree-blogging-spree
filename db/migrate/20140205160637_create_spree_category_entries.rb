class CreateSpreeCategoryEntries < ActiveRecord::Migration
  def change
    create_table :spree_category_entries, :id => false do |t|
      t.integer :blog_entry_id
      t.integer :blog_category_id

      t.timestamps
    end
  end
end
