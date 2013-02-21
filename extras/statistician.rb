class Statistician
  @queue = :statistics
  
  def self.perform(website_id)
    w = Website.find(website_id)
    
    # Generate the necessary statistic entries
    w.pages.each do |p|
      if p.statistics.size < 1 || p.statistics.last.fetch_date <= Date.today - 1.day
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
      end
    end
    
    # update the website cache
    w.facebook = w.pages.sum {|p| p.facebook }
    w.twitter = w.pages.sum {|p| p.twitter }
    w.linkedin = w.pages.sum {|p| p.linkedin }
    w.gplus = w.pages.sum {|p| p.gplus }
    w.page_cnt = w.pages.size
    w.save
    
    # update the user
    u = w.user
    u.facebook = u.websites.sum {|p| p.facebook }
    u.twitter = u.websites.sum {|p| p.twitter }
    u.linkedin = u.websites.sum {|p| p.linkedin }
    u.gplus = u.websites.sum {|p| p.gplus }
    u.page_cnt = u.websites.sum {|p| p.page_cnt.nil? ? 0 : p.page_cnt }
    u.save
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
end