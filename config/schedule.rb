# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
set :output, File.dirname(File.expand_path(__FILE__)) + "/../log/cron.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
every 1.minutes do
  command File.dirname(File.expand_path(__FILE__)) + "/../tasks/run_scraper.rb"
end

every 1.hour do
  command File.dirname(File.expand_path(__FILE__)) + "/../tasks/wipe_old_statuses.rb"
end

# Learn more: http://github.com/javan/whenever
