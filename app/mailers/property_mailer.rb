class PropertyMailer < ApplicationMailer
  prepend_view_path NotificationMailerTemplate.resolver
  ADMIN_MAILS = ["richardywall@gmail.com", "r18mantac@gmail.com"]
  def under_review(user_id, property_id, test_email=nil)#code: "template4"
	  @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      if test_email
        mail(to: [test_email], subject: "Property is Submitted for review.")
      else
        mail(to: [@user.email], subject: "Property is Submitted for review.")
        PropertyMessage.under_review(@user, @property)
      end
    end
	end

  def approved(user_id, property_id, test_email=nil)#code: "template5"
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      if test_email
        mail(to: [test_email], subject: "Property is approved for bidding.")
      else
        mail(to: [@user.email], subject: "Property is approved for bidding.")
      end
    end
  end

  def live_bidding(user_id, property_id, test_email=nil)#code: "template7"
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      if test_email
        mail(to: [test_email], subject: "Property is Live for online bidding.")
      else
        mail(to: [@user.email], subject: "Property is Live for online bidding.")
        PropertyMessage.live_bidding(@user, @property)
      end
    end
  end

  def status_notification(user_id, property_id)
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      mail(to: [@user.email], subject: "Property status is changed to #{@property.status}")
    end
  end

  def buy_now_notification(user_id, property_id, test_email=nil)#code: "template9"
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      if test_email
        mail(to: [test_email], subject: "You Win Your “Buy Now” Price…:)")
      else
        mail(to: [@user.email], subject: "You Win Your “Buy Now” Price…:)")
        PropertyMessage.buy_now_notification(@user, @property)
      end
    end
  end

  def best_offer_notification(user_id, property_id)
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      mail(to: [@user.email], subject: "Offer recieved for #{@property.address}")
    end
  end
  def bid_notification(user_id, property_id)
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      mail(to: [@user.email], subject: "Bid recieved for #{@property.address}")
    end
  end

  def best_offer(user_id, property_id, test_email=nil)#code: "template6"
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      if test_email
        mail(to: [test_email], subject: "Your Property at #{@property.address} is Approved.")
      else
        mail(to: [@user.email], subject: "Your Property at #{@property.address} is Approved.")
        PropertyMessage.best_offer(@user, @property)
      end
    end
  end

  def best_offer_ended(user_id, property_id)
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      mail(to: [@user.email], subject: "Property's Best Offer auction period is over.")
    end
  end

  def post_auction(user_id, property_id, test_email=nil)#code: "template8"
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      if test_email
        mail(to: [test_email], subject: "Property's auction period is over.")
      else
        mail(to: [@user.email], subject: "Property's auction period is over.")
        PropertyMessage.post_auction(@user, @property)
      end
    end
  end
  def sold_notification(user_id, property_id, test_email=nil)#code: "template10"
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      if test_email
        mail(to: [test_email], subject: "Way to go #{@user.first_name}...:)")
      else
        mail(to: [@user.email], subject: "Way to go #{@user.first_name}...:)")
        PropertyMessage.sold_notification(@user, @property)
      end
    end
  end

  def hold_notification(user_id, property_id, test_email=nil)#code: "template11"
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      if test_email
        mail(to: [test_email], subject: "AuctionMyDeal.com needs Your Help")
      else
        mail(to: [@user.email], subject: "AuctionMyDeal.com needs Your Help")
      end
    end
  end
  def termination_notification(user_id, property_id, test_email=nil)#code: "template12"
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      if test_email
        mail(to: [test_email], subject: "AuctionMyDeal.com is here to help You!")
      else
        mail(to: [@user.email], subject: "AuctionMyDeal.com is here to help You!")
        PropertyMessage.termination_notification(@user, @property)
      end
    end
  end
  def share_link(email, link, property_id)
    @link = link
    @property = Property.find_by(id: property_id)
    if @property
      mail(to: [email], subject: "Property is Shared.")
    end
  end
  def bid_accept(owner_id, property_id, user_id)
    @owner = User.find_by(id: owner_id)
    @property = Property.find_by(id: property_id)
    @user = User.find_by(id: user_id)
    if @owner && @property && @user
      mail(to: [@user.email], subject: "Your Bid is accepted and is in pending status.")
    end
  end
  def best_offer_accept(owner_id, property_id, user_id)
    @owner = User.find_by(id: owner_id)
    @property = Property.find_by(id: property_id)
    @user = User.find_by(id: user_id)
    if @owner && @property && @user
      mail(to: [@user.email], subject: "Your Best Offer is accepted and is in pending status.")
    end
  end
  def buy_now_accept(owner_id, property_id, user_id)
    @owner = User.find_by(id: owner_id)
    @property = Property.find_by(id: property_id)
    @user = User.find_by(id: user_id)
    if @owner && @property && @user
      mail(to: [@user.email], subject: "Your Buy Offer is accepted and is in pending status.")
    end
  end
  def buyer_best_offer_notification(buyer_id, property_id, test_email=nil)#code: "template13"
    @buyer = User.find_by(id: buyer_id)
    @property = Property.find_by(id: property_id)
    if @buyer
      if test_email
        mail(to: [test_email], subject: " Thank you for Your Best Offer on #{@property.address}!")
      else
        mail(to: [@buyer.email], subject: " Thank you for Your Best Offer on #{@property.address}!")
        PropertyMessage.buyer_best_offer_notification(@buyer, @property)
      end
    end
  end
  def watchers_post_notification(property_id, user_id, test_email=nil) #code: "template20"
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      if test_email
        mail(to: [test_email], subject: "#{@property.address} is Now Under Contract @ AuctionMyDeal.com")
      else
        mail(to: [@user.email], subject: "#{@property.address} is Now Under Contract @ AuctionMyDeal.com")
        PropertyMessage.watchers_post_notification(@user, @property)
      end
    end
  end

  def request_termination_notification(user_id, property_id)
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      mail(to: ADMIN_MAILS, subject: "Request to Terminate #{@property.status}")
      PropertyMessage.request_termination_notification(@user, @property)
    end
  end

  def urgent_chat_notification(user_id, property_id, test_email=nil) #code: "template24"
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user
      if test_email
        mail(to: test_email, subject: "AuctionMyDeal.com has an Urgent message for YOU!")
      else
        mail(to: @user.email, subject: "AuctionMyDeal.com has an Urgent message for YOU!")
        PropertyMessage.urgent_chat_notification(@user, @property)
      end
    end
  end
end
