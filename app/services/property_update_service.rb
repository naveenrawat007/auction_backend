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
      @property = PropertyTimeService.new(@property).set_property_timing
      if params[:draft] == "false"
        if @property.status == "Draft"
          @property.status = "Under Review"
          if @property.save
            CreateActivityService.new(@property, "property_posted").process!
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
      @property = PropertyTimeService.new(@property).set_property_timing_admin
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
      @landlord_deal.assign_attributes(landlord_deal_params)
    end
    @property = PropertyTimeService.new(@property).set_property_timing
    if @property.changed?
      change_logs = @property.changes
    end
    if @landlord_deal
      if @landlord_deal.changed?
        change_logs[:landlord_deal] = @landlord_deal.changes
      end
    end
    if @property.change_log
      @change_log = @property.change_log
    else
      @change_log = @property.create_change_log(details: change_logs)
    end
    unless params[:images] == nil
      if params[:images].blank? == false
        @change_log.photos.destroy_all
        params[:images].each do |image|
          @change_log.photos.create(image: image)
        end
        change_logs[:images] = "added"
      else
        change_logs[:images] = "removed"
      end
    end
    unless params[:video] == nil
      if params[:video].blank? == false
        @change_log.videos.destroy_all
        @change_log.videos.create(video: params[:video])
        change_logs[:video_url] = "added"
      else
        change_logs[:video_url] = "removed"
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
      @property = PropertyTimeService.new(@property).set_property_timing_admin
      if params[:property][:open_house_dates]
        if open_house_dates_permitter.blank? == false
          @property.open_house_dates = open_house_dates_permitter
        end
      end
      if params[:property][:residential_attributes].blank? == false
        params[:property][:residential_attributes].keys.each do |key|
          @property.residential_attributes[key] = params[:property][:residential_attributes][key]
        end
      end
      if params[:property][:commercial_attributes].blank? == false
        params[:property][:commercial_attributes].keys.each do |key|
          @property.residential_attributes[key] = params[:property][:commercial_attributes][key]
        end
      end
      if params[:property][:land_attributes].blank? == false
        params[:property][:commercial_attributes].keys.each do |key|
          @property.residential_attributes[key] = params[:property][:commercial_attributes][key]
        end
      end
      if params[:property][:buy_option]
        @property.buy_option = buy_option_permitter
      end
      @change_log = @property.change_log
      if params[:property][:images]
        if params[:property][:images] == "added"
          @property.photos.destroy_all
          @change_log.photos.update(imageable: @property)
          change_logs = @change_log.details
          change_logs["images"] = "updated"
          @change_log.update(details: change_logs)
        end
        # params[:property][:images].each do |img_url|
        #   @property.photos.create(image: open(img_url,'rb'))
        # end
      end
      if params[:property][:video_url]
        if params[:property][:video_url] == "added"
          @property.videos.destroy_all
          @change_log.videos.first.update(resource: @property)
          change_logs = @change_log.details
          change_logs["video_url"] = "updated"
          @change_log.update(details: change_logs)
        end
        # @property.videos.create(video: open(params[:property][:video_url], 'rb'))
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
      @property.save
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
  def property_update_params
    params.require(:property).permit(:address, :city, :state, :zip_code, :lat, :long, :category, :p_type, :headliner, :mls_available, :flooded, :flood_count, :description, :owner_category, :additional_information, :property_closing_amount, :seller_price, :buy_now_price, :auction_started_at, :auction_length, :auction_ending_at, :best_offer_auction_started_at, :best_offer_auction_ending_at, :show_instructions_type_id, :seller_pay_type_id, :title_status, :youtube_url, :youtube_video_key, :deal_analysis_type, :after_rehab_value, :asking_price, :estimated_rehab_cost, :profit_potential, :arv_analysis, :description_of_repairs, :vimeo_url, :dropbox_url, :rental_description, :best_offer, :best_offer_length, :best_offer_sellers_minimum_price, :best_offer_sellers_reserve_price, :show_instructions_text)
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
