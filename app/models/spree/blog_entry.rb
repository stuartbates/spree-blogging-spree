require 'acts-as-taggable-on'

class Spree::BlogEntry < ActiveRecord::Base

  attr_accessible :title, :body, :tag_list, :visible, :published_at, :summary, :permalink, :author_id, :view_count, :category_list, :blog_entry_image, :blog_entry_image_attributes, :blog_category_ids
  acts_as_taggable_on :tags, :categories

  # Events
  before_save :create_permalink
  before_save :set_published_at
  after_save :update_post_count_for_categories
  before_destroy :update_post_count_for_categories

  # Validation
  validates_presence_of :title
  validates_presence_of :body

  # Scopes
  default_scope :order => 'published_at DESC'
  scope :visible, where(:visible => true)
  scope :popular, order('view_count DESC')
  scope :recent, lambda { |max=5| visible.limit(max) }
  scope :most_popular, lambda { |max=5| visible.limit(max).popular }

  # Relations
  if Spree.user_class
    belongs_to :author, :class_name => Spree.user_class.to_s
  else
    belongs_to :author
  end

  has_one :blog_entry_image, :as => :viewable, :dependent => :destroy, :class_name => 'Spree::BlogEntryImage'
  has_many :category_entries, dependent: :delete_all, :class_name => 'Spree::CategoryEntry'
  has_many :blog_categories, :through => :category_entries

  accepts_nested_attributes_for :blog_entry_image, :reject_if => :all_blank
  accepts_nested_attributes_for :category_entries, :allow_destroy => true

  def entry_summary(chars=200)
    if summary.blank?
      "#{body[0...chars]}..."
    else
      summary
    end
  end

  class << self

    def by_date(date, period = nil)
      if date.is_a?(Hash)
        keys = [:day, :month, :year].select { |key| date.include?(key) }
        period = keys.first.to_s
        date = DateTime.new(*keys.reverse.map { |key| date[key].to_i })
      end

      time = date.to_time.in_time_zone
      where(:published_at => (time.send("beginning_of_#{period}")..time.send("end_of_#{period}")))
    end

    def by_tag(tag_name)
      tagged_with(tag_name, :on => :tags)
    end

    def by_author(author)
      where(:author_id => author)
    end

    # data for news archive widget, only visible entries
    def organize_blog_entries
      Hash.new.tap do |entries|
        years.each do |year|
          months_for(year).each do |month|
            date = DateTime.new(year, month)
            entries[year] ||= []
            entries[year] << [date.strftime("%B"), self.visible.by_date(date, :month)]
          end
        end
      end
    end
  end

protected

  def update_post_count_for_categories
    self.blog_categories.each { |c| c.update_column("post_count", c.blog_entries.count) }
  end

private

  def self.years
    visible.all.map { |e| e.published_at.year }.uniq
  end

  def self.months_for(year)
    visible.all.select { |e| e.published_at.year == year }.map { |e| e.published_at.month }.uniq
  end

  def create_permalink
    self.permalink = title.to_url if permalink.blank?
  end

  def set_published_at
    self.published_at = Time.now if published_at.blank?
  end

  def validate
    # nicEdit field contains "<br>" when blank
    errors.add(:body, "can't be blank") if body =~ /^<br>$/
  end

end 
