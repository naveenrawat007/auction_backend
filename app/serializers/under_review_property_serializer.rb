class UnderReviewPropertySerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:created_at] = object.created_at.strftime("%B %e, %Y")
    data[:updated_at] = object.updated_at.strftime("%B %e, %Y")
    data[:id] = object.id
    data[:first_name] = object.owner.first_name
    data[:last_name] = object.owner.last_name
    data[:user_type] = user_type
    data[:address] = object.address
    data[:status] = object.status
    data[:submitted_date] = object.created_at.strftime("%b %e, %Y")
    data[:auction_started_at] = object.auction_started_at ? object.auction_started_at.strftime("%b %e, %Y") : ""
    data[:auction_length] = object.auction_length
    data
  end

  def user_type
    u_type = ""
    if object.owner.type_attributes.blank? == false
      object.owner.type_attributes.each do |type|
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
