class UserSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    if self.instance_options[:serializer_options]
      data[:token] = self.instance_options[:serializer_options][:token]
    end
    data[:id] = object.id
    data[:first_name] = object.first_name
    data[:last_name] = object.last_name
    data[:email] = object.email
    data[:phone_number] = object.phone_number
    data[:is_verified] = object.is_verified
    data[:company_name] = object.company_name
    data[:company_phone] = object.company_phone
    data[:city] = object.city
    data[:state] = object.state
    data[:address] = object.address
    data[:broker_licence] = object.broker_licence
    data[:realtor_licence] = object.realtor_licence
    data[:type_attributes] = object.type_attributes
    data
  end
end
