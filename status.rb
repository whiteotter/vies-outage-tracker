require 'data_mapper'
DataMapper.setup(:default, "sqlite://#{File.dirname(File.expand_path(__FILE__))}/data/vies.db")

require_relative 'lib/status_scraper'

class Status
  extend StatusScraper
  include DataMapper::Resource

  property :id, Serial
  property :country_code, String, length: 2, index: true
  property :web_access, Boolean
  property :ws_access, Boolean
  property :created_at, DateTime
end

DataMapper.finalize
