namespace :new_mailer_template do
  desc "TODO"
  task create: :environment do
    NotificationMailerTemplate.where(code: "template25").first_or_create(title: 'Auction Guide',subject: 'Auction Guide instructions',partial: false, format: "html", locale: "en", handler: "liquid", path:"subscriber_mailer/auction_guide", body: '<b>Hello {{subscriber_name}},</b><p>Please download this pdf to know more about Auction</p><br><p style="font-size: 13px; margin: 0px;">Your Support Team @</p><p style="font-size: 13px; margin: 0px;">AuctionMyDeal.com</p><p style="font-size: 13px;">P.S.: Please let us know if you have any questions or suggestions? <a href={{help_and_faq_path}} style= "color: #28608f;" >Click HERE</a></p>')

    NotificationMailerTemplate.where(code: "template26").first_or_create(title: 'Property Share',subject: 'Auction My deal has a property for you.',partial: false, format: "html", locale: "en", handler: "liquid", path:"property_mailer/share_link", body: '<p style="font-size: 13px;">Hello, You can visit the shared property on this link <a href={{property_path}}>{{property_address}}</a>.</p><p style="font-size: 13px; margin: 0px;">Your Support Team @</p><p style="font-size: 13px; margin: 0px;">AuctionMyDeal.com</p><p style="font-size: 13px;">P.S.: Please let us know if you have any questions or suggestions? <a href={{help_and_faq_path}} style= "color: #28608f;" >Click HERE</a></p>')
  end

  task update: :environment do
  end

end
