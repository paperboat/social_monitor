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
  end
end
