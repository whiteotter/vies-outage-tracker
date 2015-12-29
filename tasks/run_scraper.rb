#!/usr/bin/env ruby
require_relative '../status'
Status.all(:created_at.lt => (Time.now.utc - (3600 * 24 * 7))).destroy
Status.scrape