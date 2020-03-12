class NotificationMailerTemplateSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:code] = object.code
    data[:title] = object.title
    data[:subject] = object.subject
    data[:body] = object.body
    data
  end
end
