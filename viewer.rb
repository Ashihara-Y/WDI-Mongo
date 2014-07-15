require 'bundler/setup'
require 'sinatra'
require 'roo'
#require 'msgpack'
#require 'oj'
require 'mongoid'
require 'mongoidsearch'
require 'yajl/json_gem'
#require 'iconv'
require 'open-uri'
require "sinatra/reloader" if development?
require 'matrix'

Mongoid.load!("./mongoid.yml", :development)

# class Downloaded_item
class Wdi_fact
  include Mongoid::Document
  #store_in collection: "downloaditem"
  field :_id, type: String
  field :country_name, type: String
  field :country_code, type: String
  field :series_name, type: String
  field :series_code, type: String
  field :content, type: Array
end

class Wdi_series
  include Mongoid::Document
  field :_id, type: String
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
end

class Wdi_country
  include Mongoid::Document
  field :_id, type: String
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
end

get '/' do
  @n = Wdi_facts.count #for current accumulated sheet number of all downloaded files
  @n_series = Wdi_series.count
  erb :index
end

get '/index' do
  @n = Wdi_facts.count #for current accumulated sheet number of all downloaded files
  @n_series = Wdi_series.count
  erb :index
end

get '/viewer' do

 uri=
   case params[:item_id].to_i
    when 1 then 'http://www.oecd.org/eco/outlook/Demand-and-Output.xls'
    when 2 then 'http://www.oecd.org/eco/outlook/Wages-Costs-Unemployment-and-Inflation.xls'
    when 3 then 'http://www.oecd.org/eco/outlook/Key-Supply-Side-Data.xls'
    when 4 then 'http://www.oecd.org/eco/outlook/Saving.xls'
    when 5 then 'http://www.oecd.org/eco/outlook/Fiscal-balances-and-Public-Indebteness.xls'
    when 6 then 'http://www.oecd.org/eco/outlook/Interest-Rates-and-Exchange-Rates.xls'
    when 7 then 'http://www.oecd.org/eco/outlook/External-Trade-and-Payments.xls'
    when 8 then 'http://www.oecd.org/eco/outlook/Other-background-Data.xls'
    else   ''
   end
  
  d_item_name = ['Demand and output', 
                 'Wages, Costs, Unemployment and Inflation', 
                 'Key Supply Side Data',
                 'Saving',
                 'Fiscal balances and public indebtedness',
                 'Interest Rates and Exchange Rates',
                 'External Trade and Payments',
                 'Other Background Data'
                ]

  d_item_name_id = (params[:item_id].to_i)
      
  d_item = Roo::Spreadsheet.open(uri)

  #RooObj 2 Matrix 2 Array
  d_item_firstsheet_narray = d_item.to_matrix.to_a

  @res = d_item_firstsheet_narray
  #@n = d_item.sheets.count #sheet number of current downloaded file
  #@d_item_id = 
  #n_Array of each sheet set to Mongo
  i = 0
  while i<d_item.sheets.count
    #d_item_matrix_i = d_item.sheet(i).to_matrix
    d_item_narray_i = d_item_matrix_i.to_a
    d_item_id = params[:item_id]
    sheet_name = d_item.sheets[i]
    sheet_name2 = d_item.sheet(i).cell('A',1).to_s
    sheet_no = i
    downloaditem = Downloaditem.create(d_item_id: d_item_id, 
                                       book_name: d_item_name[d_item_name_id-1], 
                                       sheet_id: sheet_no, 
                                       sheet_name: sheet_name,
                                       sheet_name2: sheet_name2,
                                       uri: uri, 
                                       content: d_item_narray_i)
    i +=1
  end      

  @n = Downloaditem.count #for current accumulated sheet number of all downloaded files
  #res_json = JSON.parse(res)
  @n_series = Series.count
  erb :tables
end
      
get '/sheetlist' do
  #get the name of thst sheet and embeded link(d_item_id & sheet_id) to show the sheet from Mongo
  #set the items above into array (or Hash) as instance variable
  @list_array = Downloaditem.all.asc(:book_name,:sheet_id)
  @n = Downloaditem.count
  @n_series = Series.count
  erb :sheetlist
end

get '/sheetview' do
  
  res = Downloaditem.where(d_item_id: params[:d_item_id].to_i).and(sheet_id: params[:sheet_id].to_i)
  @res = res[0].content.to_a
  @n = Downloaditem.count
  @n_series = Series.count
  erb :tables
end

get '/serieslist' do
  #@series = []
  contents = Downloaditem.where(d_item_id: 1).and(sheet_id: 0)
  matrix = Matrix.rows(contents[0].content.to_a)
  
  series_n = 3

  series_name_0 = matrix[0,0].to_s + matrix[1,0].to_s
  series_name_1 = series_name_0 + matrix[2,2].to_s + matrix[3,2].to_s
  series_name_2 = series_name_0 + matrix[2,19].to_s
  series_names = [series_name_0,series_name_1,series_name_2]
  
  country_names = matrix.minor(4..39, 0..0).to_a.flatten

  period_values_0 = matrix.minor(2..2,3..18).to_a.flatten
  period_values_1 = matrix[3,2].to_a.flatten
  period_values_2 = matrix.minor(3..3,19..21).to_a.flatten
  period_values = [period_values_0,period_values_1,period_values_2]
  
  data_values_narray_0 = matrix.minor(4..39,3..18).to_a #[[data_values01 of country A],[data_values01 of country B],,,,]
  data_values_narray_1 = matrix.minor(4..39,2..2).to_a #[data_values02 of country A,data_values02 of country B,,,,]
  data_values_narray_2 = matrix.minor(4..39,19..21).to_a #[[data_values03 of country A],[data_values03 of country B],,,,]
  data_values = [data_values_narray_0,data_values_narray_1,data_values_narray_2]
  
  #if Series.count > 0 then break else
    y = 0
  while y < series_n do
    if Series.count >0 then break end
    x = 0
    #series = []
  while x < data_values[y].size do
    narray_x = []
    i = 0
  while i < period_values[y].size do
    j = period_values[y][i]
    k = data_values[y][x][i]
    ar = []
    ar.push j,k
    narray_x.push ar
    i +=1
  end
    l = country_names[x].to_s
    #ns_ar =[]
    sheet_id = 0
    d_item_id = 1
    #ns_ar.push d_item_id,sheet_id,series_name01,l,narray_x
    #series.push ns_ar
    Series.create(d_item_id: d_item_id,
                  sheet_id: sheet_id,
                  series_id: y,
                  series_name: series_names[y],
                  country_name: l,
                  country_id: x,
                  narray: narray_x)
    x +=1
  end
    y +=1
  end
  #end
    
  @series = Series.all.asc(:d_item_id,:sheet_id,:series_id,:country_id)
  @n_series = Series.count
  @n = Downloaditem.count
  erb :serieslist
end

get '/detail' do
  @item = Series.where(d_item_id: params[:d_item_id].to_i)
                .and(sheet_id: params[:sheet_id].to_i)
                .and(series_id: params[:series_id].to_i)
                .and(country_id: params[:country_id].to_i)
  @n_series = Series.count
  @n = Downloaditem.count
  erb :detail
end
