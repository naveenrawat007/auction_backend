class LandlordDealSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:closing_cost] = object.closing_cost
    data[:short_term_financing_cost] = object.short_term_financing_cost
    data[:total_acquisition_cost] = object.total_acquisition_cost
    data[:taxes_annually] = object.taxes_annually
    data[:insurance_annually] = object.insurance_annually
    data[:amount_financed_percentage] = object.amount_financed_percentage
    data[:amount_financed] = object.amount_financed
    data[:interest_rate] = object.interest_rate
    data[:principal_interest] = object.principal_interest
    data[:taxes_monthly] = object.taxes_monthly
    data[:insurance_monthly] = object.insurance_monthly
    data[:piti_monthly_debt] = object.piti_monthly_debt
    data[:monthly_rent] = object.monthly_rent
    data[:total_gross_yearly_income] = object.total_gross_yearly_income
    data[:adjusted_gross_yearly_income] = object.adjusted_gross_yearly_income
    data[:est_annual_management_fees] = object.est_annual_management_fees
    data[:est_annual_operating_fees] = object.est_annual_operating_fees
    data[:est_annual_operating_fees_others] = object.est_annual_operating_fees_others
    data[:annual_debt] = object.annual_debt
    data[:net_operating_income] = object.net_operating_income
    data[:annual_cash_flow] = object.annual_cash_flow
    data[:monthly_cash_flow] = object.monthly_cash_flow
    data[:total_out_of_pocket] = object.total_out_of_pocket
    data[:roi_cash_percentage] = object.roi_cash_percentage
    data
  end
end
