class WdiSeries
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

  has_many :wdi_series_times

  embedded_in :Wdi_facts

  index({ series_code: 1 }, { name: 's_code_index' })
  index({ topic: 1 }, { name: 'topic_index' })
  index({ indicator_name: 1 }, { name: 's_name_index' })
end
