class Page < ActiveRecord::Base
  attr_accessible :body, :code, :depth, :headers, :page_title, :redirect_to, :referer, :response_time, :url, :website_id, :sha
  belongs_to :website
  has_many :statistics, :order => "fetch_date ASC"
  
  def facebook
    self.statistics.size < 1 ? 0 : self.statistics.last.facebook
  end
  def twitter
    self.statistics.size < 1 ? 0 : self.statistics.last.twitter
  end
  def linkedin
    self.statistics.size < 1 ? 0 : self.statistics.last.linkedin
  end
  def gplus
    self.statistics.size < 1 ? 0 : self.statistics.last.gplus
  end
end
