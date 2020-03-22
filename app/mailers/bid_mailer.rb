class BidMailer < ApplicationMailer
  prepend_view_path NotificationMailerTemplate.resolver
  def out_bidded(bid_id, test_email=nil, user_id=nil, property_id=nil)#code: "template16"
    @offer = Bid.find_by(id: bid_id)
    if @offer
  	  @buyer = User.find_by(id: @offer.user_id)
      @property = Property.find_by(id: @offer.property_id)
      if @buyer && @property
        mail(to: [@buyer.email], subject: "#{@property.address} is now Pending.")
      end
    else
      @buyer = User.find_by(id: user_id)
      @property = Property.find_by(id: property_id)
      if @buyer && @property
        mail(to: [test_email], subject: "#{@property.address} is now Pending.")
      end
    end
	end

  def submitted(bid_id, test_email=nil, user_id=nil, property_id=nil)#code: "template17"
    @offer = Bid.find_by(id: bid_id)
    if @offer
  	  @buyer = User.find_by(id: @offer.user_id)
      @property = Property.find_by(id: @offer.property_id)
      if @buyer && @property
        mail(to: [@buyer.email], subject: " Thank you for Your Offer on #{@property.address}!")
      end
    else
      @buyer = User.find_by(id: user_id)
      @property = Property.find_by(id: property_id)
      if @buyer && @property
        mail(to: [test_email], subject: " Thank you for Your Offer on #{@property.address}!")
      end
    end
  end

  def highest_bidder_notification(bid_id, test_email=nil, user_id=nil, property_id=nil)#code: "template19"
    @offer = Bid.find_by(id: bid_id)
    if @offer
  	  @buyer = User.find_by(id: @offer.user_id)
      @property = Property.find_by(id: @offer.property_id)
      if @buyer && @property
        mail(to: [@buyer.email], subject: "CONGRATULATIONS!!! You’re the Highest Bidder for  #{@property.address}!")
        BidMessage.highest_bidder_notification(@buyer, @property)
      end
    else
      @buyer = User.find_by(id: user_id)
      @property = Property.find_by(id: property_id)
      if @buyer && @property
        mail(to: [test_email], subject: "CONGRATULATIONS!!! You’re the Highest Bidder for  #{@property.address}!")
      end
    end
  end

  def termination_notification(user_id, property_id, test_email=nil)#code: "template22"
    @buyer = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @buyer && @property
      if test_email
        mail(to: [test_email], subject: "#{@property.address} is no longer on the Market")
      else
        mail(to: [@buyer.email], subject: "#{@property.address} is no longer on the Market")
      end
    end
  end

  def withdrawn_notification(user_id, property_id, test_email=nil)#code: "template23"
    @buyer = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @buyer && @property
      if test_email
        mail(to: [test_email], subject: "#{@property.address} is no longer on the Market")
      else
        mail(to: [@buyer.email], subject: "#{@property.address} is no longer on the Market")
      end
    end
  end
end
