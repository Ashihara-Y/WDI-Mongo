class WdiCountry
  include Mongoid::Document
  field :country_code, type: String
  field :short_name, type: String
  field :table_name, type: String
  field :long_name, type: String
  field :two_alpha_code, type: String
  field :currency_unit, type: String
  field :special_notes, type: String
  field :region, type: String
  field :income_group, type: String
  field :international_memberships, type: String
  field :wb2_code, type: String
  field :national_accounts_base_year, type: String
  field :national_accounts_reference_year, type: String
  field :sna_price_valuation, type: String
  field :lending_category, type: String
  field :other_groups, type: String
  field :system_of_national_accounts, type: String
  field :alternative_conversion_factor, type: String
  field :ppp_survey_year, type: String
  field :balance_of_payments_manual_in_use, type: String
  field :external_debt_reporting_status, type: String
  field :system_of_trade, type: String
  field :government_accounting_concept, type: String
  field :imf_data_dessemination_standard, type: String
  field :latest_population_census, type: String
  field :latest_household_survey, type: String
  field :source_of_most_recent_income_and_expenditure_data, type: String
  field :vital_registration_complete, type: String
  field :latest_agricultural_census, type: String
  field :latest_industrial_data, type: String
  field :latest_trade_data, type: String
  field :latest_water_withdrawal_data, type: String

  embedded_in :Wdi_facts

#  index({ country_code: 1, short_name: 1, table_name: 1, long_name: 1 }, 
#        { unique: true, name: 'c_name_index' })
#  index({ country_code: 1, two_alpha_code: 1, wb2_code: 1 }, 
#        { unique: true, name: 'c_code_index' })
#  index({ region: 1 }, { name: 'region_index' })
#  index({ income_group: 1 }, { name: 'income_index' })
#  index({ international_memberships: 1 }, { name: 'membership_index' })
#  index({ lending_category: 1 }, { name: 'lending_index' })
end
