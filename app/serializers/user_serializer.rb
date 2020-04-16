class UserSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:token] = object.auth_token
    data[:user_image] = user_image
    data[:id] = object.id
    data[:first_name] = object.first_name ? object.first_name : ""
    data[:last_name] = object.last_name ? object.last_name : ""
    data[:email] = object.email ? object.email : ""
    data[:phone_number] = object.phone_number ? object.phone_number : ""
    data[:is_verified] = object.is_verified
    data[:company_name] = object.company_name ? object.company_name : ""
    data[:company_phone] = object.company_phone ? object.company_phone : ""
    data[:city] = object.city ? object.city : ""
    data[:state] = object.state ? object.state : ""
    data[:zip_code] = object.zip_code ? object.zip_code : ""
    data[:address] = object.address ? object.address : ""
    data[:broker_licence] = object.broker_licence ? object.broker_licence : ""
    data[:realtor_licence] = object.realtor_licence ? object.realtor_licence : ""
    data[:type_attributes] = object.type_attributes
    data[:is_admin] = object.is_admin
    data[:status] = object.status
    data[:promo_code] = object.promo_code ? object.promo_code.promo_code : ""
    data[:code_availed] = object.promo_code ? object.promo_code.availed : false
    data[:has_promo_code] = object.promo_code ? true : false
    data
  end
  def user_image
    if object.photo
      APP_CONFIG['backend_site_url'] + object.photo.image.url
    else
      ""
    end
  end
end
