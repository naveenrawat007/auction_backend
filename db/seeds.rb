# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
admin = User.where(email: "admin@gmail.com", is_admin: true).first
unless admin
  User.create(first_name: "admin", last_name: "user", email: "admin@gmail.com", password: 123456, is_admin: true, is_verified: true)
end

SellerPayType.where(name: "Type1", description: "The owners title policy, 1/2 the escrow fees and prorated Taxes & HOA dues up to the day of closing/funding.").first_or_create

SellerPayType.where(name: "Type2", description: "Sellers prorated share of property Taxes & HOA dues up to the day of closing/funding. Buyer will have to pay for the owner's title policy, all escrow & closing costs.").first_or_create

ShowInstructionsType.where(name: "Type1", description: "There are no inspections of the inside of the property. Users have to bid based upon all of the information provided including a video of the property." ).first_or_create
ShowInstructionsType.where(name: "Type2", description: "Wholesaler, Owner or Realtor does one showing 24 to 72 hours before auction ends, so that bidders can show up at one time to inspect property. This should be for a 1 to 2 hour period." ).first_or_create
ShowInstructionsType.where(name: "Type3", description: "Wholesaler, Owner or Realtor gives buyer 48 business hours after they are chosen to be the Winning Bidder, subject to them putting up $1,000 non-refundable option fee for the right to inspect the property after the auction ends.").first_or_create
ShowInstructionsType.where(name: "Type4", description: "The property will be listed on mls, so buyer can call listing agent or their agent to schedule an appointment.").first_or_create
