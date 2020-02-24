class BidMailer < ApplicationMailer
  def out_bidded(bid_id)
    @offer = Bid.find_by(id: bid_id)
    if @offer
  	  @buyer = User.find_by(id: @offer.user_id)
      @property = Property.find_by(id: @offer.property_id)
      if @buyer && @property
        mail(to: [@buyer.email], subject: "#{@property.address} is now Pending.")
      end
    end
	end

  def submitted(bid_id)
    @offer = Bid.find_by(id: bid_id)
    if @offer
  	  @buyer = User.find_by(id: @offer.user_id)
      @property = Property.find_by(id: @offer.property_id)
      if @buyer && @property
        mail(to: [@buyer.email], subject: " Thank you for Your Offer on #{@property.address}!")
      end
    end
  end
end
