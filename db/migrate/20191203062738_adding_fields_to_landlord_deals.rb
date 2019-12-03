class AddingFieldsToLandlordDeals < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :after_rehab_value, :float
    add_column :properties, :asking_price, :float
    add_column :properties, :estimated_rehab_cost_attr, :json
    add_column :properties, :profit_potential, :float
    add_column :properties, :arv_analysis, :string
    add_column :properties, :description_of_repairs, :string

    change_column :properties, :estimated_rehab_cost, :float
    change_column :properties, :seller_price, :float
    change_column :properties, :buy_now_price, :float

    add_column :landlord_deals, :closing_cost, :float
    add_column :landlord_deals, :short_term_financing_cost, :float
    add_column :landlord_deals, :total_acquisition_cost, :float
    add_column :landlord_deals, :taxes_annually, :float
    add_column :landlord_deals, :insurance_annually, :float
    add_column :landlord_deals, :amount_financed_percentage, :float
    add_column :landlord_deals, :amount_financed, :float
    add_column :landlord_deals, :interest_rate, :float
    add_column :landlord_deals, :loan_terms, :integer
    add_column :landlord_deals, :principal_interest, :float
    add_column :landlord_deals, :taxes_monthly, :float
    add_column :landlord_deals, :insurance_monthly, :float
    add_column :landlord_deals, :piti_monthly_debt, :float
    add_column :landlord_deals, :monthly_rent, :float
    add_column :landlord_deals, :total_gross_yearly_income, :float
    add_column :landlord_deals, :vacancy_rate, :float
    add_column :landlord_deals, :adjusted_gross_yearly_income, :float
    add_column :landlord_deals, :est_annual_management_fees, :float
    add_column :landlord_deals, :est_annual_operating_fees, :float
    add_column :landlord_deals, :annual_debt, :float
    add_column :landlord_deals, :net_operating_income, :float
    add_column :landlord_deals, :annual_cash_flow, :float
    add_column :landlord_deals, :monthly_cash_flow, :float
    add_column :landlord_deals, :total_out_of_pocket, :float
    add_column :landlord_deals, :roi_cash_percentage, :float
  end
end
