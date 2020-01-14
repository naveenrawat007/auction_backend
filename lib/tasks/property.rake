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
end
