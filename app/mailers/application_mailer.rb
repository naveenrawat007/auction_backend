class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  private
  def liquid_assigns
    {
      'user_first_name' => user_first_name,
      'user_verification_code' => @user.verification_code,
      'new_property_path' => "#{APP_CONFIG['site_url']}/property/new",
      'reset_password_path' => reset_password_path,
      'property_address' => property_address,
      'ask_us_question_path' => "#{APP_CONFIG['site_url']}/how-everything-works/ask-us-question",
      'property_path' => property_path,
      'help_and_faq_path' => "#{APP_CONFIG['site_url']}/help-and-faq",
      'property_auction_length' => property_auction_length,
      'auction_start_time' => auction_start_time,
      'auction_bidding_ending_at' => auction_bidding_ending_at,
      'buyer_first_name' => buyer_first_name,
      'chat_room_path' => chat_room_path,
    }
  end

  def user_first_name
    return @user.first_name if @user
  end
  def user_verification_code
    return @user.verification_code if @user
  end
  def reset_password_path
    return "#{APP_CONFIG['site_url']}/new_password?reset_token=#{@user.auth_token}" if @user
  end
  def property_address
    return @property.address if @property
  end
  def property_path
    return "#{APP_CONFIG['site_url']}/property/#{@property.unique_address}" if @property
  end
  def property_auction_length
    return @property.auction_length if @property
  end
  def auction_start_time
    return (@property.best_offer_auction_started_at ? @property.best_offer_auction_started_at.strftime("%m/%d/%Y") : "") if @property
  end
  def auction_bidding_ending_at
    return (@property.auction_bidding_ending_at ? @property.auction_bidding_ending_at.strftime("%m/%d/%Y") : "") if @property
  end
  def buyer_first_name
    return  @buyer.first_name if @buyer
  end
  def chat_room_path
    return "#{APP_CONFIG['site_url']}/user/chat"
  end
end
