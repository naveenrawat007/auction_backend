class PropertySerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:address] = object.address
    data[:category] = object.category
    data[:p_type] = object.p_type
    data[:headliner] = object.headliner
    data[:mls_available] = object.mls_available
    data[:flooded] = object.flooded
    data[:flood_count] = object.flood_count
    data[:estimated_rehab_cost] = object.estimated_rehab_cost
    data[:description] = object.description
    data[:seller_price] = object.seller_price
    data[:buy_now_price] = object.buy_now_price
    data[:auction_started_at] = object.auction_started_at
    data[:auction_length] = object.auction_length
    data[:auction_ending_at] = object.auction_ending_at
    data[:status] = object.status
    data[:owner] = object.owner.first_name.to_s + " " + object.owner.last_name.to_s
    data[:seller_pay_type_id] = object.seller_pay_type_id
    data[:show_instructions_type_id] = object.show_instructions_type_id
    data[:youtube_url] = object.youtube_url
    data[:city] = object.city
    data[:state] = object.state
    data[:pay_type] = object.pay_type
    data[:title_status] = object.title_status
    data[:zip_code] = object.zip_code
    data
  end
  def user_image
    if object.photo
      APP_CONFIG['backend_site_url'] + object.photo.image.url
    else
      ""
    end
  end
end
