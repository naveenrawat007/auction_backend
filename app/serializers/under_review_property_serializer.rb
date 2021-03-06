class UnderReviewPropertySerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:created_at] = object.created_at.strftime("%m/%d/%Y")
    data[:updated_at] = object.updated_at.strftime("%m/%d/%Y")
    data[:id] = object.id
    data[:first_name] = object.owner.first_name
    data[:last_name] = object.owner.last_name
    data[:user_type] = user_type
    data[:address] = object.address
    data[:category] = object.category
    data[:land_attributes] = object.category == "Land" ? object.land_attributes : {}
    data[:residential_attributes] = object.category == "Residential" ? object.residential_attributes : {}
    data[:commercial_attributes] = object.category == "Commercial" ? object.commercial_attributes : {}
    data[:status] = object.status
    data[:submitted_at] = object.submitted_at ? object.submitted_at : ""
    data[:termination_date] = object.termination_date ? object.termination_date : ""
    data[:termination_reason] = object.termination_reason ? object.termination_reason : ""
    data[:auction_started_at] = object.auction_started_at ? object.auction_started_at : ""
    data[:auction_bidding_ending_at] = object.auction_bidding_ending_at ? object.auction_bidding_ending_at : ""
    data[:auction_length] = object.auction_length
    data[:best_offer] = object.best_offer
    data[:auction_started_at_date] = object.auction_started_at ? object.auction_started_at : ""
    data[:best_offer_auction_started_at] = object.best_offer_auction_started_at ? object.best_offer_auction_started_at : ""
    data[:best_offer_auction_ending_at] = object.best_offer_auction_ending_at ? object.best_offer_auction_ending_at : ""
    data[:submitted_at_timer] = submitted_timer
    data[:unique_address] = object.unique_address
    data[:bids] = ActiveModelSerializers::SerializableResource.new(object.bids, each_serializer: BidSerializer)
    data[:owner_category] = object.owner_category ? object.owner_category : ""
    data[:highest_bid_detail] = object.bids.order(:amount).first ? BidSerializer.new(object.bids.order(:amount).first) : {}
    data[:best_offers] = ActiveModelSerializers::SerializableResource.new(object.best_offers, each_serializer: BestOfferSerializer)
    data[:buy_now_offers] = ActiveModelSerializers::SerializableResource.new(object.buy_now_offers, each_serializer: BuyNowSerializer)
    data[:requested_at] = object.requested_at ? object.requested_at : ""
    data[:request_reason] = object.request_reason ? object.request_reason : ""
    data[:requested_status] = object.requested_status ? object.requested_status : ""
    data[:auction_type] = object.requested ? "Withdraw / Draft" : (object.status == "Under Review" ? "Under Review" : (object.best_offer ? "Best Offer" : "Live Online Bidding"))
    data[:requested] = object.requested
    data[:requested_timer] = requested_timer
    data[:sold_to] = object.property_buyer ? object.property_buyer.full_name : ""
    data[:sold_amount] = object.sold_property_record ? object.sold_property_record.offer.amount : ""
    data[:sold_date] = object.sold_date
    if self.instance_options[:serializer_options]
      if self.instance_options[:serializer_options][:status] == "Under Review"
        if object.change_log
          data[:change_log] = ChangeLogSerializer.new(object.change_log)#ChangeLogSerializer.new(ChangeLog.find(1))
        end
      end
    end
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

  def submitted_timer
    if object.submitted_at
      if (Time.now < (object.submitted_at + Property.approve_time_delay))
        (object.submitted_at + Property.approve_time_delay)
      else
        ""
      end
    else
      ""
    end
  end
  def requested_timer
    if object.requested_at
      if (Time.now < (object.requested_at + Property.approve_time_delay))
        (object.requested_at + Property.approve_time_delay)
      else
        ""
      end
    else
      ""
    end
  end

end
