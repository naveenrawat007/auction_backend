class AddingNewFieldsToOfferDetailsTables < ActiveRecord::Migration[5.2]
  def change
    add_column :offer_details, :business_document_text, :string
  end
end
