class StaticController < ApplicationController
  def index
    if user_signed_in?
      @websites = Website.find_all_by_user_id current_user.id
    end
  end
  
  def account
    if user_signed_in?
      @user = current_user
    end
  end
  
  def upgrade
    
  end
  
  def confirm_upgrade
    
  end
  
  def public
    @website = Website.find_by_public_token(params[:id])
    @stats = Hash.new
    @website.statistics.each do |s|
      if @stats[s.fetch_date].nil? 
        @stats[s.fetch_date] = {:facebook => s.facebook, :twitter => s.twitter, :gplus => s.gplus, :linkedin => s.linkedin}
      else
        @stats[s.fetch_date] = {:facebook => @stats[s.fetch_date][:facebook] + s.facebook, :twitter => @stats[s.fetch_date][:twitter] + s.twitter, :gplus => @stats[s.fetch_date][:gplus] + s.gplus, :linkedin => @stats[s.fetch_date][:linkedin] + s.linkedin}
      end
    end
  end
end
