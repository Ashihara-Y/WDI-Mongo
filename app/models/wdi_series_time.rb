class WdiSeriesTime
  include Mongoid::Document
  field :series_code, type: String
  field :year, type: String
  field :description, type: String

  belongs_to :Wdi_series

  index({ series_code: 1 }, { name: 'c_s_code_index' })
end
