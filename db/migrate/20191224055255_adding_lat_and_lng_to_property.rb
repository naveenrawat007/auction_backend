class AddingLatAndLngToProperty < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :lat, :decimal, {:precision=>10, :scale=>6}
    add_column :properties, :long, :decimal, {:precision=>10, :scale=>6}
  end
end
