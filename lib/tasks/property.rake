namespace :property do
  desc "TODO"
  task address_update: :environment do
    Property.where.not(address: [nil, ""]).each do |property|
      address = property.address
      new_address = address.split(",")
      new_address.pop
      new_address = new_address.join(",")
      property.update(address: new_address)
    end
  end
  task create_chat: :environment do #validates that buy is not seller
    Property.all.each do |property|
      property.chat_rooms.each do |chat_room|
        if property.bids.find_by(user_id: chat_room.users.where.not(id: property.owner))
          chat_room.update(offer: property.bids.find_by(user_id: chat_room.users.where.not(id: property.owner)))
        end
        if property.best_offers.find_by(user_id: chat_room.users.where.not(id: property.owner))
          chat_room.update(offer: property.best_offers.find_by(user_id: chat_room.users.where.not(id: property.owner)))
        end
        if property.buy_now_offers.find_by(user_id: chat_room.users.where.not(id: property.owner))
          chat_room.update(offer: property.buy_now_offers.find_by(user_id: chat_room.users.where.not(id: property.owner)))
        end
      end
      property.bids.each do |offer|
        unless offer.chat_room
          chat_room = offer.build_chat_room
          chat_room.property_id = offer.property_id
          chat_room.name = offer.property.address
          chat_room.save
          chat_room.users << offer.property.owner
          chat_room.users << offer.user
        end
      end
      property.best_offers.each do |offer|
        unless offer.chat_room
          chat_room = offer.build_chat_room
          chat_room.property_id = offer.property_id
          chat_room.name = offer.property.address
          chat_room.save
          chat_room.users << offer.property.owner
          chat_room.users << offer.user
        end
      end
      property.buy_now_offers.each do |offer|
        unless offer.chat_room
          chat_room = offer.build_chat_room
          chat_room.property_id = offer.property_id
          chat_room.name = offer.property.address
          chat_room.save
          chat_room.users << offer.property.owner
          chat_room.users << offer.user
        end
      end
    end
  end

  task offers_update: :environment do #validates that buy is not seller
    Property.all.each do |property|
      property.bids.each do |offer|
        if (offer.user_id == property.owner_id)
          offer.destroy
        end
      end
      property.best_offers.each do |offer|
        if (offer.user_id == property.owner_id)
          offer.destroy
        end
      end
      property.buy_nows.each do |offer|
        if (offer.user_id == property.owner_id)
          offer.destroy
        end
      end
    end
  end
  task offers_date: :environment do #validates that buy is not seller
    Property.all.each do |property|
      if property.auction_started_at.blank? == false
        if property.best_offer == true
          if property.best_offer_auction_started_at.blank? == true || property.best_offer_auction_ending_at.blank? == true
            property.best_offer_auction_started_at = property.auction_started_at.beginning_of_day + 8.hours
            property.best_offer_auction_ending_at = (property.auction_started_at.end_of_day - 4.hours) + property.best_offer_length.to_i.days
            property.auction_started_at = (property.auction_started_at + 1.day + property.best_offer_length.to_i.days).beginning_of_day + 8.hours
            property.auction_bidding_ending_at = (property.auction_started_at + property.auction_length.to_i.days).end_of_day - 4.hours
          end
          property.save_without_auditing
          if property.best_offer_auction_started_at.blank? == false
            property.best_offer_live_auction_worker_jid = Sidekiq::Client.enqueue_to_in("default", property.best_offer_auction_started_at , PropertyBestOfferWorker, property.id)
          end
          if property.best_offer_auction_ending_at.blank? == false
            property.best_offer_post_auction_worker_jid = Sidekiq::Client.enqueue_to_in("default", property.best_offer_auction_ending_at , PropertyBestOfferPostAuctionWorker, property.id)
          end
        else
          property.auction_started_at = (property.auction_started_at).beginning_of_day + 8.hours
          property.auction_bidding_ending_at = (property.auction_started_at + property.auction_length.to_i.days).end_of_day - 4.hours
        end
        property.live_auction_worker_jid = Sidekiq::Client.enqueue_to_in("default", property.auction_started_at , PropertyLiveWorker, property.id)
        property.post_auction_worker_jid = Sidekiq::Client.enqueue_to_in("default", property.auction_bidding_ending_at, PropertyPostAuctionWorker, property.id)
        property.save_without_auditing
      end
    end
  end
end
