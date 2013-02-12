class PayPalController < ApplicationController
  include ActiveMerchant::Billing::Integrations
  protect_from_forgery :except => [:create, :return, :cancel] 

  # This action is for when the buyer returns to your site from PayPal
  def return
    flash[:success] = "Thanks for supporting us! We will activate your plan upon payment confirmation! The time this takes depends on PayPal."
    redirect_to root_path
  end

  # This action is for when the buyer cancels
  def cancel
    flash[:notice] = "We're sorry you didn't buy :(. Please tell Sven at <a href='mailto:sven@paperboat.lu'>sven@paperboat</a> why you chose to cancel."
    redirect_to root_path
  end

  # This is what will receive the IPN from PayPal
  def create
    # You maybe want to log this notification
    notify = Paypal::Notification.new request.raw_post
    
    # Split the item_id
    account_id = notify.item_id
    
    @user = User.find account_id

    if notify.acknowledge
      # Make sure you received the expected payment!
      if notify.complete? and 9.99 == Decimal.new( params[:mc_gross] ) and notify.type == "subscr_payment"
        # All your bussiness logic goes here
        @user.premium = true
        @user.valid_till = Date.today + 1.month
        @user.save
        render :nothing => true
      end
    end
  end

end
