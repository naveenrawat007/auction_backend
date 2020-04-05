class OfferDetailSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:user_first_name] = object.user_first_name
    data[:user_middle_name] = object.user_middle_name
    data[:user_last_name] = object.user_last_name
    data[:user_email] = object.user_email
    data[:user_phone_no] = object.user_phone_no
    data[:self_buy_property] = object.self_buy_property
    data[:realtor_first_name] = object.realtor_first_name
    data[:realtor_last_name] = object.realtor_last_name
    data[:realtor_license] = object.realtor_license
    data[:realtor_company] = object.realtor_company
    data[:realtor_phone_no] = object.realtor_phone_no
    data[:realtor_email] = object.realtor_email
    data[:purchase_property_as] = object.purchase_property_as
    data[:internet_transaction_fee] = object.internet_transaction_fee
    data[:total_due] = object.total_due
    data[:promo_code] = object.promo_code
    data[:property_closing_date] = object.property_closing_date
    data[:hold_bid_days] = object.hold_bid_days
    data[:business_document_text] = object.business_document_text
    data[:business_documents] = documents
    data
  end

  def documents
    object.business_documents.order(:created_at).map{|i| APP_CONFIG['backend_site_url'] + i.file.url}
  end
end
