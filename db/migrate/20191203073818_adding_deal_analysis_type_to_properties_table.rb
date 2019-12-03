class AddingDealAnalysisTypeToPropertiesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :deal_analysis_type, :string
  end
end
