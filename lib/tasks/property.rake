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
