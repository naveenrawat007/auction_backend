class BuyNowOffer < ApplicationRecord
  belongs_to :property
  belongs_to :user
  has_many :fund_proofs, as: :resource, class_name: "Attachment", dependent: :destroy
  has_one :chat_room, as: :offer, dependent: :destroy
  has_one :offer_detail, as: :offer, dependent: :destroy

  after_create :accept_offer

  def accept_offer
    self.accepted = true
    self.save
  end

  def get_fund_proof
    if self.fund_proofs.blank? == false
      APP_CONFIG['backend_site_url'] + self.fund_proofs.first.file.url
    else
      ""
    end
  end
end
