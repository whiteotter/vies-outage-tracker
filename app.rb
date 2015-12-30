require 'sinatra'
require 'haml'
require 'yaml'

require_relative 'status'
EU_COUNTRIES = YAML.load_file('data/eu_countries.yml')

set :public_folder, 'public'

get '/' do
  template = <<-TEM
!!! 5
%html
  %head
    :css
      table, th, td {
        border-collapse: collapse;
        border: 1px solid black;
      }
      td > img {
        padding: 4px 0 0 5px;
      }
    %title VIES Service Tracking
  %body
    %h2 Outage Scans
    %table
      %tr
        %th Scanned at
        - eu_countries.keys.each do |country_code|
          %th= country_code
      - outage_scans.each do |scanned_at, statuses|
        %tr
          %td= scanned_at
          - eu_countries.keys.each do |country_code|
            - status = statuses.find{|status| country_code == status.country_code.upcase}
            %td
              - img_src = status ? "img/bullet-red.png" : "img/bullet-green.png"
              %img{:src => img_src, :height => 15, :width => 15}
TEM

  seven_days_ago = Time.now.utc - (3600 * 24 * 7)
  ws_access_failed_statuses = Status.all(:created_at.gte => seven_days_ago, :ws_access => false).reverse

  outage_scans = {}
  ws_access_failed_statuses.each do |status|
    outage_scans[status.created_at] ||= []
    outage_scans[status.created_at] << status
  end

  Haml::Engine.new(template).render(Object.new, outage_scans: outage_scans, eu_countries: EU_COUNTRIES)
end
