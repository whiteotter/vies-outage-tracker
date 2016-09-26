require 'mechanize'

module StatusScraper
  def scrape
    agent = Mechanize.new
    page  = agent.get('http://ec.europa.eu/taxation_customs/vies/monitoring.html')

    status_list = []
    page.search('.availability .chart span.disabled, .availability .chart span.warn').each do |span|
      status_list << { country_code: span.content, web_access: false, ws_access: false }
    end

    utc_time = Time.now.utc
    status_list.each do |status|
      self.create(country_code: status[:country_code], web_access: status[:web_access], ws_access: status[:ws_access], created_at: utc_time)
    end
  end
end
