class AuthorizePaymentsService

  def initialize(card_token, amount)
    @card_token = card_token
    @amount = (amount.to_f * 100).to_i
  end

  def call
    if amount > 0
      hold_funds()
    else
      continue_with_out_charge()
    end
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

  def continue_with_out_charge
    OpenStruct.new(card_id: "", status: "succeeded")
  end

end
