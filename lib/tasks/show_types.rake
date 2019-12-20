namespace :show_types do
  desc "TODO"
  task update: :environment do
    ShowInstructionsType.find_by(name: "Type1").update(description: "Property is vacant and easy to show as long as buyer registers their name, number, date and time of showing before they can get showing information.")
    ShowInstructionsType.find_by(name: "Type2").update(description: "Seller will set up at least 2 times to hold an open house to let interested buyers inspect the property with their contractors.")
    ShowInstructionsType.find_by(name: "Type3").update(description: "Wholesaler, Owner or Realtor gives buyer 48 business hours after they are chosen to be the Winning Bidder to inspect the property, subject to them putting up a $500 non-refundable option fee for the right to inspect the property after the auction ends. If they buy the property the option fee will be credited back to the buyer at closing, but if they terminate then they will lose the $500 for opting out of the contract.")
    ShowInstructionsType.find_by(name: "Type4").update(description: "The property will be listed on mls, so buyer can call listing agent or their agent to schedule an appointment.")
    showinst = ShowInstructionsType.where(name: "Type5").first_or_create()
    showinst.update(description: "There are no inspections of the inside of the property. Users have to bid based upon all of the information provided including a video of the property. This might make it hard to sell your property because most buyers aren’t going to buy a property without seeing the inside.")

  end
end
