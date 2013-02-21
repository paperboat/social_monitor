require 'anemone'
require 'uri'
require 'net/https'
require 'json'
require 'digest/sha1'

namespace :cron do
  
  task :daily => :environment do
    # Adding all the websites to the crawler queue
    Website.all.each do |w|
      Resque.enqueue(Crawler, w.id)
    end
  end
  
  task :crawl => :environment do
    queries = Hash.new
    puts "Starting crawler"
    Website.all.each do |w|
      if w.last_crawl.nil? || w.last_crawl + w.frequency.seconds < Time.now || w.pages.size < 1
        # Init crawler
        puts "=Crawling #{w.name}"
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
                  puts "==Looking at #{page.url}"
                  if url_acceptable(page.url.to_s, queries)
                    p = Page.find_by_sha(Digest::SHA1.hexdigest(page.body))
                    if p.nil?
                      Page.where(:website_id => w.id, :url => page.url.to_s).first_or_create(:sha => Digest::SHA1.hexdigest(page.body), :code => page.code, :depth => page.depth, :headers => page.headers, :redirect_to => page.redirect_to, :referer => page.referer, :response_time => page.response_time, :page_title => (page.doc.at('title').inner_html rescue nil))
                      puts "===Page saved: #{page.url}"
                      i+=1
                      queries[get_query(page.url.to_s)] = 1 unless get_query(page.url.to_s).nil?
                    else
                      puts "===Page discarded"
                    end
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
        puts "=Crawling ended with #{i} discovered pages"
        
    end
    # Update Page counts
    puts "Updating cached page counts"
    User.all.each do |u|
      u.websites.each do |w|
        w.page_cnt = w.pages.size
        w.save
      end
      u.page_cnt = u.websites.sum {|w| w.page_cnt }
      u.save
    end
    puts "Cache updated"
  end
  
  task :refresh => :environment do
    User.all.each do |u|
      u.page_cnt = 0
      u.save
    end
    Website.all.each do |w|
      w.page_cnt = 0
      w.save
    end
    Page.all.each do |p|
      p.destroy
    end
    Statistic.all.each do |s|
      s.destroy
    end
  end

  task :clean_pages => :environment do
    queries = Hash.new
    Page.all.each do |p|
      if !url_acceptable(p.url, queries)
        puts "Deleting #{p.url}"
        p.statistics.each do |s|
          s.destroy
        end
        p.destroy
      end
      queries[get_query(p.url.to_s)] = 1 unless get_query(p.url.to_s).nil?
    end
    
    puts "Now updating the Website caches"
    Website.all.each do |w|
      w.facebook = w.pages.sum {|p| p.facebook }
      w.twitter = w.pages.sum {|p| p.twitter }
      w.linkedin = w.pages.sum {|p| p.linkedin }
      w.gplus = w.pages.sum {|p| p.gplus }
      w.page_cnt = w.pages.size
      w.save
    end
    puts "Now updating the User caches"
    User.all.each do |u|
      u.facebook = u.websites.sum {|p| p.facebook }
      u.twitter = u.websites.sum {|p| p.twitter }
      u.linkedin = u.websites.sum {|p| p.linkedin }
      u.gplus = u.websites.sum {|p| p.gplus }
      u.page_cnt = u.websites.sum {|p| p.page_cnt }
      u.save
    end
    puts "Statistics update finished"
  end
  
  task :statistics => :environment do
    puts "Starting statistics update"
    Page.all.each do |p|
      if p.statistics.size < 1 || p.statistics.last.fetch_date <= Date.today - 1.day
        puts "=Updating #{p.url}"
        s = Statistic.new
        s.page_id = p.id
        s.fetch_date = Date.today
        s.facebook = get_fb(p.url)
        s.twitter = get_twitter(p.url)
        s.linkedin = get_linkedin(p.url)
        s.gplus = get_gplus(p.url)
        s.save
        # Save Page cache
        p.facebook = s.facebook
        p.twitter = s.twitter
        p.linkedin = s.linkedin
        p.gplus = s.gplus
        p.save
        puts "==Stats: {fb: #{s.facebook}, twitter: #{s.twitter}, linkedin: #{s.linkedin}, gplus: #{s.gplus}}"
      end
    end
    puts "Now updating the Website caches"
    Website.all.each do |w|
      w.facebook = w.pages.sum {|p| p.facebook }
      w.twitter = w.pages.sum {|p| p.twitter }
      w.linkedin = w.pages.sum {|p| p.linkedin }
      w.gplus = w.pages.sum {|p| p.gplus }
      w.page_cnt = w.pages.size
      w.save
    end
    puts "Now updating the User caches"
    User.all.each do |u|
      u.facebook = u.websites.sum {|p| p.facebook }
      u.twitter = u.websites.sum {|p| p.twitter }
      u.linkedin = u.websites.sum {|p| p.linkedin }
      u.gplus = u.websites.sum {|p| p.gplus }
      u.page_cnt = u.websites.sum {|p| p.page_cnt }
      u.save
    end
    puts "Statistics update finished"
  end
  
  task :become_admin => :environment do
    u = User.first
    u.premium = true
    u.valid_till = '2037-12-31'
    u.save
  end
end

private
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

def get_fb(url)
  uri = URI.parse("http://api.ak.facebook.com/restserver.php?v=1.0&method=links.getStats&urls=#{url}&format=json")
  response = Net::HTTP.get_response(uri)
  obj = JSON.parse(response.body)
  obj[0]["total_count"].to_i
end
  
def get_twitter(url)
  uri = URI.parse("http://urls.api.twitter.com/1/urls/count.json?url=#{url}")
  response = Net::HTTP.get_response(uri)
  obj = JSON.parse(response.body)
  obj["count"].to_i
end
  
def get_linkedin(url)
  uri = URI.parse("http://www.linkedin.com/countserv/count/share?url=#{url}&format=json")
  response = Net::HTTP.get_response(uri)
  obj = JSON.parse(response.body)
  obj["count"].to_i
end
  
def get_gplus(url)
  uri = URI.parse("https://clients6.google.com/rpc?key=AIzaSyCKSbrvQasunBoV16zDH9R33D88CeLr9gQ")
  @payload = [{
    "method" => "pos.plusones.get",
    "id"=>"p",
    "params"=>{
        "nolog"=>true,
        "id"=>"#{url}",
        "source"=>"widget",
        "userId"=>"@viewer",
        "groupId"=>"@self"
        },
    "jsonrpc"=>"2.0",
    "key"=>"p",
    "apiVersion"=>"v1"
  }].to_json
  net = Net::HTTP.new("clients6.google.com", 443)
  net.use_ssl = true
  net.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Post.new("/rpc?key=AIzaSyCKSbrvQasunBoV16zDH9R33D88CeLr9gQ", initheader = {'Content-Type' =>'application/json'})
  request.body = @payload
  response = net.request(request)
  obj = JSON.parse(response.body)
  #puts obj
  obj[0]["result"]["metadata"]["globalCounts"]["count"].to_i
end