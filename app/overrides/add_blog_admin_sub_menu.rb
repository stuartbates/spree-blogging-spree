Deface::Override.new(:virtual_path => "spree/layouts/admin",
     :name => "add_blog_admin_sub_menu",
     :insert_after => "#header",
     :partial => 'spree/admin/shared/blog_sub_menu'
)