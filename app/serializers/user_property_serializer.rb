class UserPropertySerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:created_at] = object.created_at.strftime("%m/%d/%Y")
    data[:id] = object.id
    data[:address] = object.address ? object.address : ""
    data[:headliner] = object.headliner ? object.headliner : ""
    data[:best_offer_sellers_minimum_price] = object.best_offer_sellers_minimum_price ? object.best_offer_sellers_minimum_price : ""
    data[:best_offer_price] = object.best_offer_price
    data[:best_offer_sellers_reserve_price] = object.best_offer_sellers_reserve_price ? object.best_offer_sellers_reserve_price : ""
    data[:vimeo_url] = object.vimeo_url ? object.vimeo_url : ""
    data[:dropbox_url] = object.dropbox_url ? object.dropbox_url : ""
    data[:asking_price] = object.asking_price ? object.asking_price : ""
    data[:seller_price] = object.seller_price ? object.seller_price : ""
    data[:buy_now_price] = object.buy_now_price ? object.buy_now_price : ""
    data[:status] = object.status
    data[:total_views] = object.total_views ? object.total_views : ""
    data[:arv_proof] = arv_proof
    data[:rehab_cost_proof] = rehab_cost_proof
    data[:rental_proof] = rental_proof
    data[:lat] = object.lat ? object.lat : ""
    data[:long] = object.long ? object.long : ""
    data[:highest_bid] = object.highest_bid
    data[:unique_address] = object.unique_address
    data[:thumbnail_img] = get_thumbnail
    data[:highest_buy_now] = object.get_highest_buy_now
    data[:sold_amount] = object.sold_property_record ? object.sold_property_record.offer.amount : ""
    if self.instance_options[:serializer_options]
      data[:bids] = ActiveModelSerializers::SerializableResource.new(object.bids, each_serializer: BidSerializer, serializer_options: {chat: self.instance_options[:serializer_options][:chat]})
      data[:best_offers] = ActiveModelSerializers::SerializableResource.new(object.best_offers, each_serializer: BestOfferSerializer, serializer_options: {chat: self.instance_options[:serializer_options][:chat]})
      data[:buy_now_offers] = ActiveModelSerializers::SerializableResource.new(object.buy_now_offers, each_serializer: BuyNowSerializer, serializer_options: {chat: self.instance_options[:serializer_options][:chat]})
      if self.instance_options[:serializer_options][:user].blank? == false && self.instance_options[:serializer_options][:type].blank? == false
        if self.instance_options[:serializer_options][:type] == "offer"
          data[:chat_room] = self.instance_options[:serializer_options][:user].best_offers.find_by(property_id: object.id) ?  ChatRoomSerializer.new(self.instance_options[:serializer_options][:user].best_offers.find_by(property_id: object.id).chat_room) : ""
        elsif self.instance_options[:serializer_options][:type] == "bid"
          data[:chat_room] = self.instance_options[:serializer_options][:user].bids.find_by(property_id: object.id) ? ChatRoomSerializer.new(self.instance_options[:serializer_options][:user].bids.find_by(property_id: object.id).chat_room) : ""
        elsif self.instance_options[:serializer_options][:type] == "buy_now"
          data[:chat_room] = self.instance_options[:serializer_options][:user].buy_now_offers.find_by(property_id: object.id) ? ChatRoomSerializer.new(self.instance_options[:serializer_options][:user].buy_now_offers.find_by(property_id: object.id).chat_room) : ""
        end
      end
    end
    data
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

  def get_thumbnail
    if object.photos.blank? == false
      APP_CONFIG['backend_site_url'] + object.photos.first.image.url(:thumb)
    else
      ""
    end
  end

end
