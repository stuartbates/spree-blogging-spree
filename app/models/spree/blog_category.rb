class Spree::BlogCategory < ActiveRecord::Base
  has_many :category_entries, dependent: :delete_all, :class_name => "Spree::CategoryEntry"
  has_many :blog_entries, :through => :category_entries

  attr_accessible :post_count, :title

end