class Spree::CategoryEntry < ActiveRecord::Base
  belongs_to :blog_entry, class_name: 'Spree::BlogEntry'
  belongs_to :blog_category, class_name: 'Spree::BlogCategory'

  attr_accessible :blog_category_id, :blog_entry_id
end
