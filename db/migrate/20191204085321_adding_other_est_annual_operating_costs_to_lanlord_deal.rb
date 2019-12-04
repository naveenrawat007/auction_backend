class AddingOtherEstAnnualOperatingCostsToLanlordDeal < ActiveRecord::Migration[5.2]
  def change
    add_column :landlord_deals, :est_annual_operating_fees_others, :float
  end
end
