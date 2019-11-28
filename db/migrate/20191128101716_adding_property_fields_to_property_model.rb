class AddingPropertyFieldsToPropertyModel < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :address, :string
    add_column :properties, :category, :string
    add_column :properties, :type, :string
    add_column :properties, :bedrooms, :integer
    add_column :properties, :bathrooms, :integer
    add_column :properties, :garage, :integer
    add_column :properties, :area, :string
    add_column :properties, :lot_size, :string
    add_column :properties, :year_built, :integer
    add_column :properties, :units, :integer
    add_column :properties, :price_per_sq_ft, :decimal, {:precision=>12, :scale=>2}
    add_column :properties, :headliner, :string
    add_column :properties, :ms_available, :boolean
    add_column :properties, :flooded, :boolean
    add_column :properties, :flood_count, :integer
    add_column :properties, :estimated_rehab_cost, :decimal, {:precision=>12, :scale=>2}
    add_column :properties, :description, :string
    add_column :properties, :seller_price, :decimal, {:precision=>12, :scale=>2}
    add_column :properties, :buy_now_price, :decimal, {:precision=>12, :scale=>2}
    add_column :properties, :auction_started_at, :datetime
    add_column :properties, :auction_length, :integer
    add_column :properties, :auction_ending_at, :datetime
    add_column :properties, :status, :string


    add_reference :properties, :owner
    add_reference :properties, :seller_pay_type
    add_reference :properties, :show_instructions_type
    add_column :properties, :youtube_url, :string
  end
end
