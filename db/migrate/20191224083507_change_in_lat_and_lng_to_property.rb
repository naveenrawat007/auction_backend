class ChangeInLatAndLngToProperty < ActiveRecord::Migration[5.2]
  def change
    change_column :properties, :lat, :decimal, {:precision=>10, :scale=>7}
    change_column :properties, :long, :decimal, {:precision=>10, :scale=>7}
  end
end
