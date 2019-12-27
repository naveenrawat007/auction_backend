namespace :property_unique_address do
  desc "TODO"
  task generate: :environment do
    Property.where(unique_address: [nil, ""]).each do |property|
      if property.address.blank? == false
        property.unique_address = property.address.strip.split(/\W/).join("_") + "_#{property.id}"
      else
        property.unique_address = "porperty_address_" + "#{property.id}"
      end
      property.save
    end
  end
end
