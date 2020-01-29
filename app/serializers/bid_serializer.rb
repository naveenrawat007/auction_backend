class BidSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:amount] = object.amount
    data[:type] = "Bid"
    data[:user] = object.user ? object.user.first_name : ""
    data[:user_name] = object.user ? "#{object.user.first_name} #{object.user.last_name}" : ""
    data[:time] = object.updated_at.strftime("%m/%d/%Y | %l:%M%p")
    data[:fund_proof] = object.get_fund_proof
    data[:user_type] = user_type
    data[:accepted] = object.accepted
    if self.instance_options[:serializer_options]
      if self.instance_options[:serializer_options][:chat]
        data[:chat_room] = ChatRoomSerializer.new(object.chat_room)
      end
    end
    data
  end
  def user_type
    u_type = ""
    if object.user.type_attributes.blank? == false
      object.user.type_attributes.each do |type|
        if type[1] == true
          u_type = type[0]
          break
        end
      end
    end
    if u_type.include?("Inves")
      "Investor"
    else
      "Realtor"
    end
  end
end
