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
    %title VIES Service Tracking
  %body
    %h2 Vies Service Outages
    %ul
      - eu_countries.each do |country_code, country_name|
        %li
          - country_url = "/country?code=" + country_code
          %a{:href => country_url, :title => country_name}= country_name
TEM
  Haml::Engine.new(template).render(Object.new, eu_countries: EU_COUNTRIES)
end

get '/country' do
  country_code = params['code'].upcase
  unless EU_COUNTRIES.keys.include? country_code
    redirect to('/')
  end

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
    %h2= country_title = eu_countries[country_code] + " Outage Scans"
    %table
      %tr
        %th Scanned at
        %th Ws Access
        %th Web Access
      - outage_scans.each do |outage_scan|
        %tr
          %td= outage_scan.created_at
          %td
            - img_src = outage_scan.ws_access ? "img/bullet-green.png" : "img/bullet-red.png"
            %img{:src => img_src, :height => 15, :width => 15}
          %td
            - img_src = outage_scan.web_access ? "img/bullet-green.png" : "img/bullet-red.png"
            %img{:src => img_src, :height => 15, :width => 15}
TEM

  seven_days_ago = Time.now.utc - (3600 * 24 * 7)
  ws_access_failed_statuses = Status.all(:country_code => country_code, :ws_access => false, :created_at.gte => seven_days_ago).reverse

  Haml::Engine.new(template).render(Object.new, outage_scans: ws_access_failed_statuses, country_code: country_code, eu_countries: EU_COUNTRIES)
end
