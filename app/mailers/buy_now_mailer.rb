class BuyNowMailer < ApplicationMailer
  prepend_view_path NotificationMailerTemplate.resolver

  def submitted(buy_now_id, test_email=nil, user_id=nil, property_id=nil) #code: "template18"
    @offer = BuyNowOffer.find_by(id: buy_now_id)
    if @offer
  	  @buyer = User.find_by(id: @offer.user_id)
      @property = Property.find_by(id: @offer.property_id)
      if @buyer && @property
        if test_email
          mail(to: [test_email], subject: " Congrats for choosing to “BUY NOW” @ AuctionMyDeal.com")
        else
          mail(to: [@buyer.email], subject: " Congrats for choosing to “BUY NOW” @ AuctionMyDeal.com")
        end
      end
    else
      @buyer = User.find_by(id: user_id)
      @property = Property.find_by(id: property_id)
      if @buyer && @property
        mail(to: [test_email], subject: "CONGRATULATIONS!!! You’re the Highest Bidder for  #{@property.address}!")
      end
    end
  end
  def out_bidded_notification(user_id, property_id, test_email=nil)#code: "template21"
    @buyer = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @buyer && @property
      if test_email
        mail(to: [test_email], subject: "You’ve been Outbid for #{@property.address}")
      else
        mail(to: [@buyer.email], subject: "You’ve been Outbid for #{@property.address}")
      end
    end
  end
end
