class CaptureFundsService

  def initialize(card_id)
    @card_id = card_id
  end

  def call
    charge_amount()
  end

  private

  attr_accessor :card_id

  def charge_amount
    charge = Stripe::Charge.capture(card_id)
  end

end
