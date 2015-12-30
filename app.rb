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
    %h2 Statuses
    - country_status_lists.each do |country_code, statuses|
      %h3= eu_countries[country_code]
      %table
        %tr
          %th{:style => "padding-right:30px;"} ws access
          %th{:style => "padding-right:20px;"} web access
          %th outage noted at
        - statuses.each do |status|
          %tr
            %td{:style => "text-align:center;"}
              - img_src = status.ws_access ? "img/bullet-green.png" : "img/bullet-red.png"
              %img{:src => img_src, :height => 15, :width => 15}
            %td{:style => "text-align:center;"}
              - img_src = status.web_access ? "img/bullet-green.png" : "img/bullet-red.png"
              %img{:src => img_src, :height => 15, :width => 15}
            %td{:style => "text-align:center;"}= status.created_at

TEM

  seven_days_ago = Time.now.utc - (3600 * 24 * 7)
  web_access_failed_statuses = Status.all(:created_at.gte => seven_days_ago, :web_access => false)
  ws_access_failed_statuses  = Status.all(:created_at.gte => seven_days_ago, :ws_access => false)
  all_statuses = (web_access_failed_statuses | ws_access_failed_statuses).sort_by{ |status| status.created_at }.reverse

  country_status_lists = {}
  all_statuses.each do |status|
    country_status_lists[status.country_code] ||= []
    country_status_lists[status.country_code] << status
  end

  Haml::Engine.new(template).render(Object.new, country_status_lists: country_status_lists, eu_countries: EU_COUNTRIES)
end
