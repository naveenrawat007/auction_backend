class MainMessage
  private
  def self.manage_body(message, user=nil, property=nil)
    # puts message
    msg = message
    if message.include?("{user_verification_code}")
      if user
        msg = msg.gsub("{user_verification_code}", user.verification_code)
      end
    end
    if message.include?("{password_reset_path}")
      if user
        msg = msg.gsub("{password_reset_path}", "#{APP_CONFIG['site_url']}/new_password?reset_token=#{user.auth_token}")
      end
    end
    puts message
    if message.include?("{property_address}")
      if property
        msg = msg.gsub("{property_address}", property.address)
      end
    end
    return msg
  end
end
