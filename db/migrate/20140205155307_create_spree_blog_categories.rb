class CreateSpreeBlogCategories < ActiveRecord::Migration
  def change
    create_table :spree_blog_categories do |t|
      t.string :title
      t.integer :post_count

      t.timestamps
    end
  end
end
