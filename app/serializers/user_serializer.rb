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
    data
  end
end
