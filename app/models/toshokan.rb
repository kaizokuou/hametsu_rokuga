class Toshokan
  RAW_URL = ["http://tokyotosho.info/?cat=7","http://tokyotosho.info/?page=1&cat=7","http://tokyotosho.info/?page=2&cat=7","http://tokyotosho.info/?page=3&cat=7","http://tokyotosho.info/?page=4&cat=7"]
  def self.runner
    Nyaa.runner
    Daddict.runner
    agent = Mechanize.new
    RAW_URL.each do |raw_url|
      page = agent.get URI.parse raw_url
      page.root.xpath("//td[@class='desc-top']").to_ary.each do |a|
        link = process_td a
        p link['title']
        save_link link
      end
    end
    return true
  end

  def self.pager page
    agent = Mechanize.new
    page = agent.get URI.parse RAW_URL+"&page=#{page}"
    page.root.xpath("//td[@class='desc-top']").to_ary.each do |a|
      link = process_td a
      save_link link
    end
    return true
  end


  def self.process_td td
    link = td.xpath("a").first.attributes.to_hash
    title = td.xpath("a").first.children.to_ary.first.to_s
    href = process_torrent_link link['href'].to_s
    return {'type' => link["type"].to_s, 'href' => href, 'title' => title}
  end

  def self.process_torrent_link str
    return str unless str =~ /nyaatorrents/
    return str.gsub(/torrentinfo/,'download')
  end

  def self.save_link link
    begin
      Entity.find "torrent/#{CGI.escape link['href']}"
    rescue
      e = Entity.create 'id' => "torrent/#{CGI.escape link['href']}", 'href' => link['href'], 'title' => link['title'], "created_at" => Time.now.to_i
      e.add_to_index "torrent_list", Time.now.to_i
      e.add_to_index "torrent_raw_list", Time.now.to_i
    end
  end
end
