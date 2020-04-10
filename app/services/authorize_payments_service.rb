class AuthorizePaymentsService

  def initialize(card_token, amount)
    @card_token = card_token
    @amount = amount
  end

  def call
    hold_funds()
  end

  private

  attr_accessor :amount, :card_token

  def hold_funds()
    charge = Stripe::Charge.create({
      amount: amount,
      currency: 'usd',
      description: 'hold funds from card',
      source: card_token,
      capture: false,
    })

    OpenStruct.new(card_id: charge.id, status: charge.status)

  end

end
