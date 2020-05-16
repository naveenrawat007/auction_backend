# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_16_092429) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "viewed", default: false
    t.string "act_type"
    t.integer "resource_id"
    t.string "resource_type"
    t.index ["resource_id", "resource_type"], name: "index_activities_on_resource_id_and_resource_type"
  end

  create_table "attachments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.integer "resource_id"
    t.string "resource_type"
    t.string "name"
    t.index ["resource_type", "resource_id"], name: "index_attachments_on_resource_type_and_resource_id"
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.json "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "best_offers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "amount"
    t.boolean "accepted", default: false
    t.bigint "property_id"
    t.bigint "user_id"
    t.json "buy_option"
    t.index ["property_id"], name: "index_best_offers_on_property_id"
    t.index ["user_id"], name: "index_best_offers_on_user_id"
  end

  create_table "bids", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "amount"
    t.boolean "accepted", default: false
    t.bigint "property_id"
    t.bigint "user_id"
    t.json "buy_option"
    t.index ["property_id"], name: "index_bids_on_property_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "buy_now_offers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "amount"
    t.boolean "accepted", default: false
    t.bigint "property_id"
    t.bigint "user_id"
    t.boolean "best_offer", default: false
    t.json "buy_option"
    t.index ["property_id"], name: "index_buy_now_offers_on_property_id"
    t.index ["user_id"], name: "index_buy_now_offers_on_user_id"
  end

  create_table "change_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "details"
    t.bigint "property_id"
    t.index ["property_id"], name: "index_change_logs_on_property_id"
  end

  create_table "chat_rooms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.bigint "property_id"
    t.integer "offer_id"
    t.string "offer_type"
    t.boolean "open_connection", default: true
    t.index ["offer_type", "offer_id"], name: "index_chat_rooms_on_offer_type_and_offer_id"
    t.index ["property_id"], name: "index_chat_rooms_on_property_id"
  end

  create_table "landlord_deals", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "closing_cost"
    t.float "short_term_financing_cost"
    t.float "total_acquisition_cost"
    t.float "taxes_annually"
    t.float "insurance_annually"
    t.float "amount_financed_percentage"
    t.float "amount_financed"
    t.float "interest_rate"
    t.integer "loan_terms"
    t.float "principal_interest"
    t.float "taxes_monthly"
    t.float "insurance_monthly"
    t.float "piti_monthly_debt"
    t.float "monthly_rent"
    t.float "total_gross_yearly_income"
    t.float "vacancy_rate"
    t.float "adjusted_gross_yearly_income"
    t.float "est_annual_management_fees"
    t.float "est_annual_operating_fees"
    t.float "annual_debt"
    t.float "net_operating_income"
    t.float "annual_cash_flow"
    t.float "monthly_cash_flow"
    t.float "total_out_of_pocket"
    t.float "roi_cash_percentage"
    t.bigint "property_id"
    t.float "est_annual_operating_fees_others"
    t.index ["property_id"], name: "index_landlord_deals_on_property_id"
  end

  create_table "messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "content"
    t.bigint "user_id"
    t.bigint "chat_room_id"
    t.boolean "recipient_read", default: false
    t.index ["chat_room_id"], name: "index_messages_on_chat_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notification_mailer_templates", force: :cascade do |t|
    t.text "body"
    t.string "path"
    t.string "locale"
    t.string "handler"
    t.boolean "partial", default: false
    t.string "format"
    t.string "subject"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mail_type"
    t.string "title"
  end

  create_table "notification_message_templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "path"
    t.string "body"
    t.string "code"
    t.string "title"
  end

  create_table "offer_details", force: :cascade do |t|
    t.string "user_first_name"
    t.string "user_middle_name"
    t.string "user_last_name"
    t.string "user_email"
    t.string "user_phone_no"
    t.string "string"
    t.boolean "self_buy_property", default: false
    t.string "realtor_first_name"
    t.string "realtor_last_name"
    t.string "realtor_license"
    t.string "realtor_company"
    t.string "realtor_phone_no"
    t.string "realtor_email"
    t.string "purchase_property_as"
    t.float "internet_transaction_fee"
    t.float "total_due"
    t.string "promo_code"
    t.datetime "property_closing_date"
    t.integer "hold_bid_days"
    t.bigint "offer_id"
    t.string "offer_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "business_document_text"
    t.string "stripe_card_id"
  end

  create_table "photos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "imageable_id"
    t.string "imageable_type"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.index ["imageable_type", "imageable_id"], name: "index_photos_on_imageable_type_and_imageable_id"
  end

  create_table "promo_codes", force: :cascade do |t|
    t.string "promo_code"
    t.bigint "user_id"
    t.boolean "availed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["promo_code"], name: "index_promo_codes_on_promo_code"
    t.index ["user_id"], name: "index_promo_codes_on_user_id"
  end

  create_table "properties", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.string "category"
    t.string "p_type"
    t.string "headliner"
    t.boolean "mls_available"
    t.boolean "flooded"
    t.string "flood_count"
    t.float "estimated_rehab_cost"
    t.string "description"
    t.float "seller_price"
    t.float "buy_now_price"
    t.datetime "auction_started_at"
    t.integer "auction_length"
    t.datetime "auction_ending_at"
    t.string "status"
    t.bigint "owner_id"
    t.bigint "seller_pay_type_id"
    t.bigint "show_instructions_type_id"
    t.string "youtube_url"
    t.string "city"
    t.string "state"
    t.string "title_status"
    t.string "zip_code"
    t.json "residential_attributes"
    t.json "commercial_attributes"
    t.json "land_attributes"
    t.float "after_rehab_value"
    t.float "asking_price"
    t.json "estimated_rehab_cost_attr"
    t.float "profit_potential"
    t.string "arv_analysis"
    t.string "description_of_repairs"
    t.string "deal_analysis_type"
    t.json "buy_option"
    t.integer "total_views", default: 0
    t.datetime "submitted_at"
    t.string "additional_information"
    t.boolean "best_offer", default: false
    t.integer "best_offer_length"
    t.float "best_offer_sellers_minimum_price"
    t.float "best_offer_sellers_reserve_price"
    t.string "show_instructions_text"
    t.json "open_house_dates"
    t.string "vimeo_url"
    t.string "dropbox_url"
    t.string "owner_category"
    t.string "rental_description"
    t.string "youtube_video_key"
    t.decimal "lat", precision: 10, scale: 7
    t.decimal "long", precision: 10, scale: 7
    t.string "unique_address"
    t.datetime "termination_date"
    t.string "termination_reason"
    t.string "requested_status"
    t.datetime "requested_at"
    t.string "request_reason"
    t.boolean "sniper", default: false
    t.integer "sniper_length", default: 0
    t.boolean "requested", default: false
    t.string "post_auction_worker_jid"
    t.boolean "submitted", default: false
    t.datetime "auction_bidding_ending_at"
    t.datetime "best_offer_auction_started_at"
    t.datetime "best_offer_auction_ending_at"
    t.string "best_offer_post_auction_worker_jid"
    t.string "best_offer_live_auction_worker_jid"
    t.string "live_auction_worker_jid"
    t.float "property_closing_amount"
    t.datetime "sold_date"
    t.index ["owner_id"], name: "index_properties_on_owner_id"
    t.index ["seller_pay_type_id"], name: "index_properties_on_seller_pay_type_id"
    t.index ["show_instructions_type_id"], name: "index_properties_on_show_instructions_type_id"
    t.index ["unique_address"], name: "index_properties_on_unique_address", unique: true
  end

  create_table "seller_pay_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "description"
  end

  create_table "show_instructions_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "description"
  end

  create_table "sold_properties", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "property_id"
    t.integer "offer_id"
    t.string "offer_type"
    t.index ["offer_type", "offer_id"], name: "index_sold_properties_on_offer_type_and_offer_id"
    t.index ["property_id"], name: "index_sold_properties_on_property_id"
    t.index ["user_id"], name: "index_sold_properties_on_user_id"
  end

  create_table "subscribers", force: :cascade do |t|
    t.string "name"
    t.bigint "phone_no"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_chat_rooms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "chat_room_id"
    t.index ["chat_room_id"], name: "index_user_chat_rooms_on_chat_room_id"
    t.index ["user_id"], name: "index_user_chat_rooms_on_user_id"
  end

  create_table "user_watch_properties", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "property_id"
    t.index ["property_id"], name: "index_user_watch_properties_on_property_id"
    t.index ["user_id"], name: "index_user_watch_properties_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "company_name"
    t.string "company_phone"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "broker_licence"
    t.string "realtor_licence"
    t.string "auth_token"
    t.boolean "is_admin", default: false
    t.json "type_attributes"
    t.string "verification_code"
    t.boolean "is_verified", default: false
    t.string "zip_code"
    t.string "status"
    t.datetime "trial_ending_at"
    t.string "stipe_customer_id"
    t.string "stripe_customer_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "video_file_name"
    t.string "video_content_type"
    t.integer "video_file_size"
    t.datetime "video_updated_at"
    t.integer "resource_id"
    t.string "resource_type"
    t.index ["resource_type", "resource_id"], name: "index_videos_on_resource_type_and_resource_id"
  end

  create_table "visitors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "phone_number"
    t.string "email"
    t.string "question"
  end

end
