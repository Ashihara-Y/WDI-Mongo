require 'bundler/setup'
require 'sinatra'
require 'roo'
require 'searchkick'
#require 'oj'
require 'mongoid'
#require 'mongoid_search'
require 'yajl/json_gem'
#require 'iconv'
require 'open-uri'
require "sinatra/reloader" if development?
require 'matrix'

Mongoid.load!("./mongoid.yml", :development)

# WDI model classes 
class Wdi_fact
  include Mongoid::Document

  field :country_name, type: String
  field :country_code, type: String
  field :series_name, type: String
  field :series_code, type: String
  field :content, type: Array

  has_one :Wdi_series
  embeds_one :Wdi_country

  index({ country_code: 1, series_code: 1 }, { unique: true, name: "c_s_code_index", background: true })

  index "wdi_country.country_name" => 1
  index "wdi_country.region" => 1
  index "wdi_country.income_group" => 1
  index "wdi_country.international_membership" => 1
  index "wdi_country.lending_category" => 1
end

class Wdi_series
  include Mongoid::Document
  field :series_code, type: String
  field :topic, type: String
  field :dataset, type: String
  field :indicator_name, type: String
  field :dataset, type: String
  field :short_definition, type: String
  field :long_definition, type: String
  field :unit_of_measure, type: String
  field :power_code, type: String
  field :periodicity, type: String
  field :base_period, type: String
  field :reference_period, type: String
  field :other_notes, type: String
  field :derivation_method, type: String
  field :aggregation_method, type: String
  field :limitations_and_exceptions, type: String
  field :notes_from_original_source, type: String
  field :general_comments, type: String
  field :source, type: String
  field :data_quality, type: String
  field :statistical_concept_and_methodology, type: String
  field :development_relevance, type: String
  field :related_source, type: String
  field :other_web_links, type: String
  field :related_indicators, type: String

  belongs_to :Wdi_facts

  index({ series_code: 1 }, { name: "s_code_index" })
  index({ topic: 1 }, { name: "topic_index" })
  index({ indicator_name: 1 }, { name: "s_name_index" })
end

class Wdi_country
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

  #index({ country_code: 1, short_name: 1, table_name: 1, long_name: 1 }, { unique: true, name: "c_name_index" })
  #index({ country_code: 1, two_alpha_code: 1, wb2_code: 1 }, { unique: true, name: "c_code_index" })
  #index({ region: 1 }, { name: "region_index" })
  #index({ income_group: 1 }, { name: "income_index" })
  #index({ international_memberships: 1 }, { name: "membership_index" })
  #index({ lending_category: 1 }, { name: "lending_index" })
end

get '/' do
  @n = Wdi_fact.count #for current accumulated sheet number of all downloaded files
  @n_series = Wdi_series.count
  erb :index
end

get '/index' do
  @n = Wdi_fact.count #for current accumulated sheet number of all downloaded files
  @n_series = Wdi_series.count
  erb :index
end

get '/tableview' do
  res01 = Wdi_fact.where(country_code: "USA").and(series_code: "PX.REX.REER").first
  res02 = Wdi_fact.where(country_code: "JPN").and(series_code: "PX.REX.REER").first
  @res = res02.content
  @n = Wdi_fact.count
  @n_series = Wdi_series.count
  erb :tables
end

get '/detail' do
  res01 = Wdi_fact.where(country_code: "USA").and(series_code: "PX.REX.REER").first
  res02 = Wdi_fact.where(country_code: "JPN").and(series_code: "PX.REX.REER").first

  @item = res02.content
  @n_series = Wdi_series.count
  @n = Wdi_fact.count
  erb :detail
end
