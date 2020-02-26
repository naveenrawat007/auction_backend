class BestOfferMailer < ApplicationMailer
  def not_accepted(offer_id)
    @offer = BestOffer.find_by(id: offer_id)
    if @offer
  	  @buyer = User.find_by(id: @offer.user_id)
      @property = Property.find_by(id: @offer.property_id)
      if @buyer && @property
        mail(to: [@buyer.email], subject: "Are you still interested in buying #{@property.address}???.")
      end
    end
	end
  def out_bidded(offer_id)
    @offer = BestOffer.find_by(id: offer_id)
    if @offer
  	  @buyer = User.find_by(id: @offer.user_id)
      @property = Property.find_by(id: @offer.property_id)
      if @buyer && @property
        mail(to: [@buyer.email], subject: "#{@property.address} is now Pending.")
      end
    end
	end
end
