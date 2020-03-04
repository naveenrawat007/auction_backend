class PropertyUpdateService
  include ApplicationHelper
  attr_reader :property, :params, :current_user
 	def initialize(property, params, current_user)
	  @property = property
   	@params = params
   	@current_user = current_user
 	end

 	def user_process!
    if @property.update(property_update_params)
      if params[:property][:residential_attributes].blank? == false
        @property.residential_attributes = residential_type_attributes_permitter
      end
      if params[:property][:commercial_attributes].blank? == false
        @property.commercial_attributes = commercial_type_attributes_permitter
      end
      if params[:property][:land_attributes].blank? == false
        @property.land_attributes = land_type_attributes_permitter
      end
      if params[:property][:open_house_dates]
        if open_house_dates_permitter.blank? == false
          @property.open_house_dates = open_house_dates_permitter
        end
      end
      if params[:property][:estimated_rehab_cost_attr]
        @property.estimated_rehab_cost_attr = estimated_rehab_cost_attributes_permitter
      end
      if params[:property][:buy_option]
        @property.buy_option = buy_option_permitter
      end
      if params[:images].blank? == false
        @property.photos.destroy_all
        params[:images].each do |image|
          @property.photos.create(image: image)
        end
      end
      if params[:video].blank? == false
        @property.videos.destroy_all
        @property.videos.create(video: params[:video])
      end
      if params[:arv_proof].blank? == false
        @property.arv_proofs.destroy_all
        @property.arv_proofs.create(file: params[:arv_proof], name: "Arv Proof")
      end
      if params[:rehab_cost_proof].blank? == false
        @property.rehab_cost_proofs.destroy_all
        @property.rehab_cost_proofs.create(file: params[:rehab_cost_proof], name: "Rehab Cost Proof")
      end
      if params[:rental_proof].blank? == false
        @property.rental_proofs.destroy_all
        @property.rental_proofs.create(file: params[:rental_proof], name: "Rental Proof")
      end
      if @property.deal_analysis_type == "Rehab & Flip Deal"
        if params[:property][:profit_potential].blank? == false
          @property.profit_potential = params[:property][:profit_potential]
        end
      elsif @property.deal_analysis_type == "Landlord Deal"
        if @property.landlord_deal
          @landlord_deal = @property.landlord_deal
        else
          @landlord_deal = @property.build_landlord_deal
        end
        @landlord_deal.update(landlord_deal_params)
        @landlord_deal.save
      end
      @property = set_property_timing(@property)
      if @property.auction_ending_at.blank? == false
        if @property.auction_ending_at.to_i != @property.auction_ending_at.end_of_day.to_i
          @property.auction_ending_at = @property.auction_ending_at.end_of_day
        end
      end
      if params[:draft] == "false"
        if @property.status == "Draft"
          @property.status = "Under Review"
          if @property.save
            @property.submitted = true
            @property.submitted_at = Time.now
            @property.save
            Sidekiq::Client.enqueue_to_in("default", Time.now + Property.approve_time_delay, PropertyApproveWorker, @property.id)
            Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyUnderReviewWorker, @current_user.id, @property.id)
          end
        end
      else
        @property.save
      end
      return OpenStruct.new(status: "success")
    else
      return OpenStruct.new(status: "failure")
    end
 	end
  def admin_process!
    if @property.update(property_update_params)
      if params[:property][:residential_attributes].blank? == false
        @property.residential_attributes = residential_type_attributes_permitter
      end
      if params[:property][:commercial_attributes].blank? == false
        @property.commercial_attributes = commercial_type_attributes_permitter
      end
      if params[:property][:land_attributes].blank? == false
        @property.land_attributes = land_type_attributes_permitter
      end
      if params[:property][:open_house_dates]
        if open_house_dates_permitter.blank? == false
          @property.open_house_dates = open_house_dates_permitter
        end
      end
      if params[:property][:estimated_rehab_cost_attr]
        @property.estimated_rehab_cost_attr = estimated_rehab_cost_attributes_permitter
      end
      if params[:property][:buy_option]
        @property.buy_option = buy_option_permitter
      end
      if params[:images].blank? == false
        @property.photos.destroy_all
        params[:images].each do |image|
          @property.photos.create(image: image)
        end
      end
      if params[:video].blank? == false
        @property.videos.destroy_all
        @property.videos.create(video: params[:video])
      end
      if params[:arv_proof].blank? == false
        @property.arv_proofs.destroy_all
        @property.arv_proofs.create(file: params[:arv_proof], name: "Arv Proof")
      end
      if params[:rehab_cost_proof].blank? == false
        @property.rehab_cost_proofs.destroy_all
        @property.rehab_cost_proofs.create(file: params[:rehab_cost_proof], name: "Rehab Cost Proof")
      end
      if params[:rental_proof].blank? == false
        @property.rental_proofs.destroy_all
        @property.rental_proofs.create(file: params[:rental_proof], name: "Rental Proof")
      end
      if @property.deal_analysis_type == "Rehab & Flip Deal"
        if params[:property][:profit_potential].blank? == false
          @property.profit_potential = params[:property][:profit_potential]
        end
      elsif @property.deal_analysis_type == "Landlord Deal"
        if @property.landlord_deal
          @landlord_deal = @property.landlord_deal
        else
          @landlord_deal = @property.build_landlord_deal
        end
        @landlord_deal.update(landlord_deal_params)
        @landlord_deal.save
      end
      @property = set_property_timing_admin(@property)
      if @property.auction_ending_at.blank? == false
        if @property.auction_ending_at.to_i != @property.auction_ending_at.end_of_day.to_i
          @property.auction_ending_at = @property.auction_ending_at.end_of_day
        end
      end
      return OpenStruct.new(status: "success")
    else
      return OpenStruct.new(status: "failure")
    end
 	end

  def user_property_log_process!
    # params[:property].keys.each do |key|
    #   @property[key] = params[:property][key]
    #   if @property.changed?
    #   end
    # end
    change_logs = {}
    @property.assign_attributes(property_update_params)
    if params[:property][:residential_attributes].blank? == false
      @property.residential_attributes = residential_type_attributes_permitter
    end
    if params[:property][:commercial_attributes].blank? == false
      @property.commercial_attributes = commercial_type_attributes_permitter
    end
    if params[:property][:land_attributes].blank? == false
      @property.land_attributes = land_type_attributes_permitter
    end
    if params[:property][:open_house_dates]
      if open_house_dates_permitter.blank? == false
        @property.open_house_dates = open_house_dates_permitter
      end
    end
    if params[:property][:estimated_rehab_cost_attr]
      @property.estimated_rehab_cost_attr = estimated_rehab_cost_attributes_permitter
    end
    if params[:property][:buy_option]
      @property.buy_option = buy_option_permitter
    end
    # if params[:images].blank? == false
    #   @property.photos.destroy_all
    #   params[:images].each do |image|
    #     @property.photos.create(image: image)
    #   end
    # end
    # if params[:video].blank? == false
    #   @property.videos.destroy_all
    #   @property.videos.create(video: params[:video])
    # end
    # if params[:arv_proof].blank? == false
    #   @property.arv_proofs.destroy_all
    #   @property.arv_proofs.create(file: params[:arv_proof], name: "Arv Proof")
    # end
    # if params[:rehab_cost_proof].blank? == false
    #   @property.rehab_cost_proofs.destroy_all
    #   @property.rehab_cost_proofs.create(file: params[:rehab_cost_proof], name: "Rehab Cost Proof")
    # end
    # if params[:rental_proof].blank? == false
    #   @property.rental_proofs.destroy_all
    #   @property.rental_proofs.create(file: params[:rental_proof], name: "Rental Proof")
    # end
    if @property.deal_analysis_type == "Rehab & Flip Deal"
      if params[:property][:profit_potential].blank? == false
        @property.profit_potential = params[:property][:profit_potential]
      end
    elsif @property.deal_analysis_type == "Landlord Deal"
      if @property.landlord_deal
        @landlord_deal = @property.landlord_deal
      else
        @landlord_deal = @property.build_landlord_deal
      end
      @landlord_deal.assign_attributes(landlord_deal_params)
    end
    @property = set_property_timing(@property)
    if @property.auction_ending_at.blank? == false
      if @property.auction_ending_at.to_i != @property.auction_ending_at.end_of_day.to_i
        @property.auction_ending_at = @property.auction_ending_at.end_of_day
      end
    end
    if @property.changed?
      change_logs = @property.changes
    end
    if @landlord_deal
      if @landlord_deal.changed?
        change_logs[:landlord_deal] = @landlord_deal.changes
      end
    end
    if change_logs.blank? == false
      if @property.change_log
        details = @property.change_log.details
        details.merge(change_logs)
        @property.change_log.details = details.merge(change_logs)
        @property.change_log.save
      else
        @property.create_change_log(details: change_logs)
      end
      set_submitted(@property.id)
      Sidekiq::Client.enqueue_to_in("default", Time.now + Property.approve_time_delay, PropertyApproveWorker, @property.id)
    end
    return OpenStruct.new(status: "success")
  end

  def admin_property_change_log_update_process!
    if @property.update(property_update_params)
      if @property.deal_analysis_type == "Rehab & Flip Deal"
        if params[:property][:profit_potential].blank? == false
          @property.profit_potential = params[:property][:profit_potential]
        end
      elsif @property.deal_analysis_type == "Landlord Deal"
        if @property.landlord_deal
          @landlord_deal = @property.landlord_deal
        else
          @landlord_deal = @property.build_landlord_deal
        end
        @landlord_deal.update(landlord_deal_params)
        @landlord_deal.save
      end
      return OpenStruct.new(status: "success")
    else
      return OpenStruct.new(status: "failure")
    end
  end
  private
  def set_submitted(property_id)
    property = Property.find_by(id: property_id)
    property.status = "Under Review"
    if property.submitted == false
      property.submitted_at = Time.now
    end
    property.submitted = true
    property.save
  end
  def set_property_timing(property)
    if property.best_offer == true
      if property.best_offer_auction_started_at.blank? == false
        if property.best_offer_auction_started_at.to_i != (property.best_offer_auction_started_at.beginning_of_day + 8.hours).to_i
          property.best_offer_auction_started_at = property.best_offer_auction_started_at.beginning_of_day + 8.hours
        end
      end
      if property.best_offer_auction_ending_at.blank? == false
        if property.best_offer_auction_ending_at.to_i != (property.best_offer_auction_ending_at.end_of_day - 4.hours).to_i
          property.best_offer_auction_ending_at = property.best_offer_auction_ending_at.end_of_day - 4.hours
          property.auction_started_at = (property.best_offer_auction_ending_at + 1.day).beginning_of_day + 8.hours
          property.auction_bidding_ending_at = (property.auction_started_at + property.auction_length.to_i.days).beginning_of_day - 4.hours
        end
      end
    end
    if property.auction_started_at.blank? == false
      if property.auction_started_at.to_i != (property.auction_started_at.beginning_of_day + 8.hours).to_i
        property.auction_started_at = property.auction_started_at.beginning_of_day + 8.hours
        property.auction_bidding_ending_at = (property.auction_started_at + property.auction_length.to_i.days).beginning_of_day - 4.hours
      end
    end
    if property.auction_bidding_ending_at == false
      if property.auction_bidding_ending_at.to_i != (property.auction_started_at + property.auction_length.to_i.days).beginning_of_day - 4.hours
        property.auction_bidding_ending_at = (property.auction_started_at + property.auction_length.to_i.days).beginning_of_day - 4.hours
      end
    end
    return property
  end
  def set_property_timing_admin(property)
    if property.best_offer == true
      if property.best_offer_auction_started_at.blank? == false
        if property.best_offer_auction_started_at.to_i != (property.best_offer_auction_started_at.beginning_of_day + 8.hours).to_i
          property.best_offer_auction_started_at = property.best_offer_auction_started_at.beginning_of_day + 8.hours
          best_offer_live_auction(property)
        end
      end
      if property.best_offer_auction_ending_at.blank? == false
        if property.best_offer_auction_ending_at.to_i != (property.best_offer_auction_ending_at.end_of_day - 4.hours).to_i
          property.best_offer_auction_ending_at = property.best_offer_auction_ending_at.end_of_day - 4.hours
          property.auction_started_at = (property.best_offer_auction_ending_at + 1.day).beginning_of_day + 8.hours
          property.auction_bidding_ending_at = (property.auction_started_at + property.auction_length.to_i.days).beginning_of_day - 4.hours
          best_offer_post_auction(property)
        end
      end
    end
    if property.auction_started_at.blank? == false
      if property.auction_started_at.to_i != (property.auction_started_at.beginning_of_day + 8.hours).to_i
        property.auction_started_at = property.auction_started_at.beginning_of_day + 8.hours
        property.auction_bidding_ending_at = (property.auction_started_at + property.auction_length.to_i.days).beginning_of_day - 4.hours
      end
    end
    if property.auction_bidding_ending_at == false
      if property.auction_bidding_ending_at.to_i != (property.auction_started_at + property.auction_length.to_i.days).beginning_of_day - 4.hours
        property.auction_bidding_ending_at = (property.auction_started_at + property.auction_length.to_i.days).beginning_of_day - 4.hours
      end
    end
    live_auction(property)
    post_auction(property)
    return property
  end
  def property_update_params
    params.require(:property).permit(:address, :city, :state, :zip_code, :lat, :long, :category, :p_type, :headliner, :mls_available, :flooded, :flood_count, :description, :owner_category, :additional_information, :seller_price, :buy_now_price, :auction_started_at, :auction_length, :auction_ending_at, :best_offer_auction_started_at, :best_offer_auction_ending_at, :show_instructions_type_id, :seller_pay_type_id, :title_status, :youtube_url, :youtube_video_key, :deal_analysis_type, :after_rehab_value, :asking_price, :estimated_rehab_cost, :profit_potential, :arv_analysis, :description_of_repairs, :vimeo_url, :dropbox_url, :rental_description, :best_offer, :best_offer_length, :best_offer_sellers_minimum_price, :best_offer_sellers_reserve_price, :show_instructions_text)
  end
  def open_house_dates_permitter
    JSON.parse(params[:property][:open_house_dates])
  end

  def buy_option_permitter
    JSON.parse(params[:property][:buy_option])
  end

  def residential_type_attributes_permitter
    JSON.parse(params[:property][:residential_attributes])
  end
  def commercial_type_attributes_permitter
    JSON.parse(params[:property][:commercial_attributes])
  end
  def land_type_attributes_permitter
    JSON.parse(params[:property][:land_attributes])
  end
  def estimated_rehab_cost_attributes_permitter
    JSON.parse(params[:property][:estimated_rehab_cost_attr])
  end
  def landlord_deal_params
    params.require(:property).permit(:closing_cost, :short_term_financing_cost, :total_acquisition_cost, :taxes_annually, :insurance_annually, :amount_financed_percentage, :amount_financed, :interest_rate, :loan_terms, :principal_interest, :taxes_monthly, :insurance_monthly, :piti_monthly_debt, :monthly_rent, :total_gross_yearly_income, :vacancy_rate, :adjusted_gross_yearly_income, :est_annual_management_fees, :est_annual_operating_fees, :annual_debt, :net_operating_income, :annual_cash_flow, :monthly_cash_flow, :total_out_of_pocket, :roi_cash_percentage, :est_annual_operating_fees_others)
  end
end
