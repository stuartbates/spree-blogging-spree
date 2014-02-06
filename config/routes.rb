Spree::Core::Engine.routes.draw do
  namespace :admin do

    resources :blog_entries
    resources :blog_categories
  end

  resources :blog_entries

  match '/blog/tag/:tag', :to => 'blog_entries#tag', :as => :blog_tag
  match '/blog/category/:category', :to => 'blog_entries#category', :as => :blog_category
  match '/blog/author/:author', :to => 'blog_entries#author', :as => :blog_author
  match '/blog/:year/:month/:day/:slug', :to => 'blog_entries#show', :as => :blog_entry_permalink
  match '/blog/:year(/:month)(/:day)', :to => 'blog_entries#archive', :as => :news_archive,
        :constraints => {:year => /(19|20)\d{2}/, :month => /[01]?\d/, :day => /[0-3]?\d/}
  match '/blog/feed', :to => 'blog_entries#feed', :as => :blog_feed, :format => :rss
  match '/blog', :to => 'blog_entries#index', :as => :blog
end