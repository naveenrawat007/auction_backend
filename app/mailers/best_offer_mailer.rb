class BestOfferMailer < ApplicationMailer
  prepend_view_path NotificationMailerTemplate.resolver
  def not_accepted(offer_id, test_email=nil, user_id=nil, property_id=nil)#code: "template14"
    @offer = BestOffer.find_by(id: offer_id)
    if @offer
      @buyer = User.find_by(id: @offer.user_id)
      @property = Property.find_by(id: @offer.property_id)
      if @buyer && @property
        mail(to: [@buyer.email], subject: "Are you still interested in buying #{@property.address}???.")
      end
    else
      @buyer = User.find_by(id: user_id)
      @property = Property.find_by(id: property_id)
      if @buyer && @property
        mail(to: [test_email], subject: "Are you still interested in buying #{@property.address}???.")
      end
    end
	end
  def out_bidded(offer_id, test_email=nil, user_id=nil, property_id=nil)#template15
    @offer = BestOffer.find_by(id: offer_id)
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
end
