class Website < ActiveRecord::Base
  attr_accessible :frequency, :last_crawl, :name, :root_url, :user_id, :public_token
  belongs_to :user
  has_many :pages
  has_many :statistics, :through => :pages
  
  before_create :create_public_token
  before_save :check_http
  
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
  
  def create_public_token
    self.public_token = SecureRandom.urlsafe_base64
  end
  
  def check_http
    self.root_url = "http://#{root_url}" if self.root_url.index("http://").nil? && self.root_url.index("https://").nil?
  end
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
end
