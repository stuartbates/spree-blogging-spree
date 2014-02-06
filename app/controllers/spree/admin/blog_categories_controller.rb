class Spree::Admin::BlogCategoriesController < Spree::Admin::ResourceController

  private

  def location_after_save
    edit_admin_blog_category_url(@blog_category)
  end

end