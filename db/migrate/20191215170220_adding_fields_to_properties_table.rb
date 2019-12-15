class AddingFieldsToPropertiesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :additional_information, :string
    add_column :properties, :best_offer, :boolean, default: false
    add_column :properties, :best_offer_lenght, :integer
    add_column :properties, :best_offer_sellers_minimum_price, :float
    add_column :properties, :best_offer_sellers_reserve_price, :float
    add_column :properties, :show_instructions_text, :string
    add_column :properties, :open_house_dates, :json
    add_column :properties, :vimeo_url, :string
    add_column :properties, :dropbox_url, :string
    add_column :properties, :owner_categogry, :string
  end
end
