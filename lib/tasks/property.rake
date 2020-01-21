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
end
