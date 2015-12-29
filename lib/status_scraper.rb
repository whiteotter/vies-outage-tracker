require 'mechanize'

module StatusScraper
  def scrape
    agent = Mechanize.new
    page  = agent.get('http://ec.europa.eu/taxation_customs/vies/technicalInformation.html')

    status_list = []
    page.search('div.layout-content tr').each do |tr|
      country_code, country_name = nil, nil
      bullets = []

      tr.children.each do |td|
        next unless td.name == 'td'
        if td['class'] == 'labelLeft'
          country_code, country_name = td.content.split('-', 2) if td.content =~ /.*-.*/
        elsif td['class'] == 'labelCenter'
          img = td.children[1]
          if img && img.name == 'img' && img['src'] =~ /bullet-[green|red]/
            bullets << (img['src'] =~ /bullet-green/ ? true : false)
          end
        end
      end

      web_access, ws_access = bullets.first(2)
      status = { country_code: country_code, country_name: country_name, web_access: web_access, ws_access: ws_access }
      status_list << status if status.values.all?{ |e| !e.nil? }
    end

    utc_time = Time.now.utc
    status_list.each do |status|
      next if (status[:ws_access] && status[:web_access])
      self.create(country_code: status[:country_code], web_access: status[:web_access], ws_access: status[:ws_access], created_at: utc_time)
    end
  end
end
