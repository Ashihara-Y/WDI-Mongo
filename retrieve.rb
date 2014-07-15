require 'bundler/setup'
require 'sinatra'
require 'mongoid'
require 'yajl/json_gem'
require 'open-uri'

Mongoid.load!("./mongoid.yml", :development)

# class Downloaded_item
class Downloaditem
  include Mongoid::Document
  #store_in collection: "downloaditem"
  field :d_item_id, type: Integer
  field :item_id, type: Integer
  field :sheet_id, type: Integer
  field :sheet_name, type: String
  field :sheet_name2, type: String
  field :uri, type: String
  field :content, type: Array
end
      
get '/serieslist' do
  @point = []
  @firstrow = []
  @firstcolumn = []
  Downloaditem.each do |donwloaditem|
    matrix = Matrix(downloaditem.content)
    @point << matrix.(0,0)
    @firstrow << matrix.row(0)
    @firstcolumn << matrix.column(0)
  end      
  erb :serieslist
end
