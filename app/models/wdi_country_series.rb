class WdiCountrySeries
  include Mongoid::Document
  field :country_code, type: String
  field :series_code, type: String
  field :description, type: String

  belongs_to :Wdi_fact

  index({ country_code: 1, series_code: 1 }, 
        { name: 'c_s_code_index' })
end
