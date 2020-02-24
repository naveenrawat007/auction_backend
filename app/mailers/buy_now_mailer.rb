class BuyNowMailer < ApplicationMailer

  def submitted(buy_now_id)
    @offer = BuyNowOffer.find_by(id: buy_now_id)
    if @offer
  	  @buyer = User.find_by(id: @offer.user_id)
      @property = Property.find_by(id: @offer.property_id)
      if @buyer && @property
        mail(to: [@buyer.email], subject: " Congrats for choosing to “BUY NOW” @ AuctionMyDeal.com")
      end
    end
  end
end
