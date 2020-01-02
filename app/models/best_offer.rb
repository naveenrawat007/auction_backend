class BestOffer < ApplicationRecord
  belongs_to :property
  belongs_to :user
  has_many :fund_proofs, as: :resource, class_name: "Attachment"

  def get_fund_proof
    if self.fund_proofs.blank? == false
      APP_CONFIG['backend_site_url'] + self.fund_proofs.first.file.url
    else
      ""
    end
  end
end