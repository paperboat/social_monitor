class Website < ActiveRecord::Base
  attr_accessible :frequency, :last_crawl, :name, :root_url, :user_id
  belongs_to :user
  has_many :pages
  has_many :statistics, :through => :pages
  
  def facebook
    self.pages.sum(:facebook)
  end
  def twitter
    self.pages.sum(:twitter)
  end
  def linkedin
    self.pages.sum(:linkedin)
  end
  def gplus
    self.pages.sum(:gplus)
  end
end
