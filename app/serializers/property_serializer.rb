class PropertySerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:created_at] = object.created_at.strftime("%B %e, %Y")
    data[:updated_at] = object.updated_at.strftime("%B %e, %Y")
    data[:id] = object.id
    data[:address] = object.address
    data[:city] = object.city
    data[:state] = object.state
    data[:zip_code] = object.zip_code
    data[:category] = object.category
    data[:p_type] = object.p_type
    data[:headliner] = object.headliner
    data[:mls_available] = object.mls_available
    data[:flooded] = object.flooded
    data[:flood_count] = object.flood_count
    data[:owner_category] = object.owner_category
    data[:additional_information] = object.additional_information
    data[:buy_option] = object.buy_option
    data[:best_offer] = object.best_offer
    data[:best_offer_length] = object.best_offer_length
    data[:best_offer_sellers_minimum_price] = object.best_offer_sellers_minimum_price
    data[:best_offer_sellers_reserve_price] = object.best_offer_sellers_reserve_price
    data[:show_instructions_text] = object.show_instructions_text
    data[:open_house_dates] = object.open_house_dates.blank? == false ? object.open_house_dates  : []
    data[:vimeo_url] = object.vimeo_url
    data[:dropbox_url] = object.dropbox_url
    data[:description] = object.description
    data[:deal_analysis_type] = object.deal_analysis_type
    data[:after_rehab_value] = object.after_rehab_value
    data[:asking_price] = object.asking_price
    data[:estimated_rehab_cost] = object.estimated_rehab_cost
    data[:profit_potential] = object.profit_potential ? object.profit_potential : ""
    data[:estimated_rehab_cost_attr] = object.estimated_rehab_cost_attr

    if object.landlord_deal.blank? == false
      data[:landlord_deal] = LandlordDealSerializer.new(object.landlord_deal)
    end
    data[:arv_analysis] = object.arv_analysis
    data[:description_of_repairs] = object.description_of_repairs
    data[:rental_description] = object.rental_description
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
    data[:title_status] = object.title_status
    data[:total_views] = object.total_views
    data[:images] = property_images
    data[:arv_proof] = arv_proof
    data[:rehab_cost_proof] = rehab_cost_proof
    data[:rental_proof] = rental_proof
    data[:land_attributes] = object.category == "Land" ? object.land_attributes : {}
    data[:residential_attributes] = object.category == "Residential" ? object.residential_attributes : {}
    data[:commercial_attributes] = object.category == "Commercial" ? object.commercial_attributes : {}
    data[:show_instructions] = object.show_instructions_type ? object.show_instructions_type.description : ""
    data
  end
  def property_images
    object.photos.order(:created_at).map{|i| APP_CONFIG['backend_site_url'] + i.image.url}
  end

  def arv_proof
    if object.arv_proofs.last
      APP_CONFIG['backend_site_url'] + object.arv_proofs.last.file.url
    else
      ""
    end
  end

  def rehab_cost_proof
    if object.rehab_cost_proofs.last
      APP_CONFIG['backend_site_url'] + object.rehab_cost_proofs.last.file.url
    else
      ""
    end
  end

  def rental_proof
    if object.rental_proofs.last
      APP_CONFIG['backend_site_url'] + object.rental_proofs.last.file.url
    else
      ""
    end
  end
end
