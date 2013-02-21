class Crawler
  @queue = :crawl

  def self.perform(website_id)
    w = Website.find(website_id)
    
    queries = Hash.new
    # check whether we really need to crawl
    if w.last_crawl.nil? || w.last_crawl + w.frequency.seconds < Time.now || w.pages.size < 1
      # Init crawler
      i = w.pages.size
      # Crawl
      # Check whether we need to look at the page
      if w.user.premium || i < 20
        Anemone.crawl(w.root_url) do |anemone|
          # Check whether we need to look at the page
          if w.user.premium || i < 20
            anemone.on_every_page do |page|
              # Check whether we need to look at the page
              if w.user.premium || i < 20
                if url_acceptable(page.url.to_s, queries)
                  p = Page.find_by_sha(Digest::SHA1.hexdigest(page.body))
                  if p.nil?
                    Page.where(:website_id => w.id, :url => page.url.to_s).first_or_create(:sha => Digest::SHA1.hexdigest(page.body), :code => page.code, :depth => page.depth, :headers => page.headers, :redirect_to => page.redirect_to, :referer => page.referer, :response_time => page.response_time, :page_title => (page.doc.at('title').inner_html rescue nil))
                    i+=1
                    queries[get_query(page.url.to_s)] = 1 unless get_query(page.url.to_s).nil?
                  end
                end
              end
            end
          end
        end
      end
      
      w.last_crawl = Time.now
      w.page_cnt = w.pages.size
      w.save
      
      # Update the user page count
      u = w.user
      u.page_cnt = u.websites.sum {|w| w.page_cnt }
      u.save
      
      # Enqueue the website for the statistics gatherer
      Resque.enqueue(Statistician, w.id)
      
    end
  end
  
  def url_acceptable(url, queries)
    url.index(/\.pdf$/).nil? &&
    url.index("%23").nil? &&
    # To handle problems with wordpress
    url.index('replytocom=').nil? &&
    url.index(/\?tag=/).nil? &&
    url.index(/\?cat=/).nil? &&
    url.index(/\?paged=/).nil? &&
    url.index(/\/\?$/).nil? &&
    url.index('showComment=').nil? &&
    !queries.include?(get_query(url))
  end

  def get_query(url)
    url.slice(/\?.*$/)
  end
  
end