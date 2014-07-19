class WdiFact
  include Mongoid::Document
  field :country_name, type: String
  field :country_code, type: String
  field :series_name, type: String
  field :series_code, type: String
  field :content, type: Array

  has_many :wdi_country_series
  has_many :wdi_footnotes

  embeds_one :Wdi_series
  embeds_one :Wdi_country

  index({ country_code: 1, series_code: 1 }, 
        { unique: true, name: 'c_s_code_index', background: true }
  )
end
