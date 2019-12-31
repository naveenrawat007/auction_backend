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
    data
  end
end
