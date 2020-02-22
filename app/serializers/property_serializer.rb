class PropertySerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:created_at] = object.created_at.strftime("%m/%d/%Y")
    data[:updated_at] = object.updated_at.strftime("%m/%d/%Y")
    data[:id] = object.id
    data[:address] = object.address ? object.address : ""
    data[:city] = object.city ? object.city : ""
    data[:state] = object.state ? object.state : ""
    data[:zip_code] = object.zip_code ? object.zip_code : ""
    data[:category] = object.category ? object.category : ""
    data[:p_type] = object.p_type ? object.p_type : ""
    data[:headliner] = object.headliner ? object.headliner : ""
    data[:mls_available] = object.mls_available ? object.mls_available : false
    data[:flooded] = object.flooded ? object.flooded : false
    data[:flood_count] = object.flood_count ? object.flood_count : ""
    data[:owner_category] = object.owner_category ? object.owner_category : ""
    data[:additional_information] = object.additional_information ? object.additional_information : ""
    data[:buy_option] = object.buy_option.blank? == false ? object.buy_option : []
    data[:best_offer] = object.best_offer
    data[:best_offer_length] = object.best_offer_length ? object.best_offer_length : ""
    data[:best_offer_time_pending] = check_best_offer_time
    data[:best_offer_auction_started_at] = object.best_offer_auction_started_at ? object.best_offer_auction_started_at : ""
    data[:best_offer_auction_ending_at] = object.best_offer_auction_ending_at ? object.best_offer_auction_ending_at : ""
    data[:best_offer_sellers_minimum_price] = object.best_offer_sellers_minimum_price ? object.best_offer_sellers_minimum_price : ""
    data[:best_offer_price] = object.best_offer_price
    data[:best_offer_sellers_reserve_price] = object.best_offer_sellers_reserve_price ? object.best_offer_sellers_reserve_price : ""
    data[:show_instructions_text] = object.show_instructions_text ? object.show_instructions_text : ""
    data[:open_house_dates] = object.open_house_dates.blank? == false ? object.open_house_dates  : [{date: "", opens: "", closes: ""}]
    data[:vimeo_url] = object.vimeo_url ? object.vimeo_url : ""
    data[:dropbox_url] = object.dropbox_url ? object.dropbox_url : ""
    data[:description] = object.description ? object.description : ""
    data[:deal_analysis_type] = object.deal_analysis_type ? object.deal_analysis_type : ""
    data[:after_rehab_value] = object.after_rehab_value ? object.after_rehab_value : ""
    data[:asking_price] = object.asking_price ? object.asking_price : ""
    data[:estimated_rehab_cost] = object.estimated_rehab_cost ? object.estimated_rehab_cost : ""
    data[:profit_potential] = object.profit_potential ? object.profit_potential : ""
    data[:estimated_rehab_cost_attr] = object.estimated_rehab_cost_attr.blank? == false ? object.estimated_rehab_cost_attr : {}

    if object.landlord_deal.blank? == false
      data[:landlord_deal] = LandlordDealSerializer.new(object.landlord_deal)
    end
    data[:arv_analysis] = object.arv_analysis ? object.arv_analysis : ""
    data[:description_of_repairs] = object.description_of_repairs ? object.description_of_repairs : ""
    data[:rental_description] = object.rental_description ? object.rental_description : ""
    data[:seller_price] = object.seller_price ? object.seller_price : ""
    data[:buy_now_price] = object.buy_now_price ? object.buy_now_price : ""
    data[:auction_started_at] = object.auction_started_at ? object.auction_started_at : ""
    data[:auction_length] = object.auction_length ? object.auction_length : ""
    data[:auction_bidding_started_at] = object.auction_started_at ? object.auction_started_at : ""
    data[:auction_bidding_ending_at] = object.auction_bidding_ending_at ? object.auction_bidding_ending_at : ""
    data[:auction_ending_at] = object.auction_ending_at ? object.auction_ending_at : ""
    data[:closing_date] = object.auction_ending_at ? object.auction_ending_at.strftime("%m/%d/%Y") : ""
    data[:status] = object.status
    data[:owner] = object.owner.first_name.to_s + " " + object.owner.last_name.to_s
    data[:seller_pay_type_id] = object.seller_pay_type_id ? object.seller_pay_type_id : ""
    data[:show_instructions_type_id] = object.show_instructions_type_id ? object.show_instructions_type_id : ""
    data[:youtube_url] = object.youtube_url ? object.youtube_url : ""
    data[:youtube_video_key] = object.youtube_video_key ? object.youtube_video_key : ""
    data[:title_status] = object.title_status ? object.title_status : ""
    data[:total_views] = object.total_views ? object.total_views : ""
    data[:images] = property_images
    data[:arv_proof] = arv_proof
    data[:rehab_cost_proof] = rehab_cost_proof
    data[:rental_proof] = rental_proof
    data[:land_attributes] = object.category == "Land" ? object.land_attributes : {}
    data[:residential_attributes] = object.category == "Residential" ? object.residential_attributes : {}
    data[:commercial_attributes] = object.category == "Commercial" ? object.commercial_attributes : {}
    data[:show_instructions] = object.show_instructions_type ? object.show_instructions_type.description : ""
    data[:lat] = object.lat ? object.lat : ""
    data[:long] = object.long ? object.long : ""
    data[:images_details] = ActiveModelSerializers::SerializableResource.new(object.photos.order(:created_at), each_serializer: PhotoSerializer)
    data[:highest_bid] = object.highest_bid
    data[:unique_address] = object.unique_address
    data[:bids] = ActiveModelSerializers::SerializableResource.new(object.bids, each_serializer: BidSerializer)
    data[:best_offers] = ActiveModelSerializers::SerializableResource.new(object.best_offers, each_serializer: BestOfferSerializer)
    data[:buy_now_offers] = ActiveModelSerializers::SerializableResource.new(object.buy_now_offers, each_serializer: BuyNowSerializer)
    data[:thumbnail_img] = get_thumbnail
    data[:video_url] = get_video_url
    data[:video_thumb] = get_video_thumbnail
    data
  end
  def get_video_url
    if object.videos.blank? == false
      APP_CONFIG['backend_site_url'] + object.videos.first.video.url
    else
      ""
    end
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

  def check_best_offer_time
    if object.best_offer == true
      if object.best_offer_auction_started_at
        if (Time.now < object.best_offer_auction_ending_at)
          true
        else
          false
        end
      end
    else
      false
    end
  end
  def get_thumbnail
    if object.photos.blank? == false
      APP_CONFIG['backend_site_url'] + object.photos.first.image.url(:thumb)
    else
      ""
    end
  end
  def get_video_thumbnail
    if object.videos.blank? == false
      APP_CONFIG['backend_site_url'] + object.videos.first.video.url(:thumb)
    else
      ""
    end
  end
end
