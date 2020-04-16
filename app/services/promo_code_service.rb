class PromoCodeService
  attr_reader :user, :range

  def initialize(user)
	  @user = user
    @range = [*'0'..'9',*'A'..'Z',*'a'..'z']
 	end

  def generated_code!
    promo_code = user.build_promo_code
    code = Array.new(7){ range.sample }.join
    last_id = PromoCode.last ? PromoCode.last.id : 1
    generated_code = get_code(code, last_id)
    if PromoCode.find_by(promo_code: generated_code)
      generated_code = get_code(code, last_id)
    else
      promo_code.promo_code = generated_code
      promo_code.save
    end
    return promo_code
  end

  def update_availed_code(code)
    promo_code = PromoCode.find_by(promo_code: generated_code)
    if promo_code
      promo_code.update(availed: true)
    end
  end

  private
  def get_code(code, id)
    code = code[0, (code.length - id.to_s.length)]
    code = code + id.to_s
    code
  end
end
