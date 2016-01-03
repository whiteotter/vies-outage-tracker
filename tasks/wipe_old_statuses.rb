#!/usr/bin/env ruby
require_relative '../status'

# limit to last 7 days
Status.all(:created_at.lt => (Time.now.utc - (3600 * 24 * 7))).destroy

# stay under heroku 10k rows limit
if Status.count > 9000
  Status.first(1000).destroy
end
