class PropertyApproveWorker
  include ApplicationHelper
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id)
    property = Property.find_by(id: property_id)
    if property
      if property.status == "Under Review"
        property.status = "Approve"
        property.submitted = false
        if property.save
          PropertyMailer.approved(property.owner_id, property.id).deliver
          if property.auction_started_at.blank? == false
            if property.best_offer == true
              if property.best_offer_auction_started_at.blank? == false
                best_offer_live_auction(property)
              end
              if property.best_offer_auction_ending_at.blank? == false
                best_offer_post_auction(property)
              end
            end
            live_auction(property)
            post_auction(property)
          else
            property.status = "Hold"
            property.save
            Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyNotificationWorker, property.id)
          end
        end
      end
    end
  end
end
