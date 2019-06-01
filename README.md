# vies-outage-tracker
Tracking of [VAT Information Exchange System](http://ec.europa.eu/taxation_customs/vies/technicalInformation.html) outages

## Local Set Up
- Create a postgres database 'vies_status_scraper'
- After running `bundle`, run `whenever -w` to setup web scraper and data paring cron jobs on local machine
- `ruby app.rb` to fire up sinatra app (or run `irb` then `require './app.rb'` to load up app in console environment)

- test trigger
