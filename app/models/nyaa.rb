class Nyaa
  Nyaa_URLs = JSON.parse(Entity.find("setting").nyaa_urls)
  def self.runner
    Nyaa_URLs.each do |nurl|
      agent = Mechanize.new
      page = agent.get URI.parse nurl
      page.root.xpath("//tr[@class='tlistrow']").to_ary.each do |a|
        url = a.children[3].children.first.attributes.to_hash["href"].to_s
        title = a.children[1].children.first.attributes.to_hash["title"].to_s
        begin
          Entity.find "torrent/#{CGI.escape url}"
        rescue
          e = Entity.create 'id' => "torrent/#{CGI.escape url}", 'href' => url, 'title' => title, "created_at" => Time.now.to_i
          e.add_to_index "torrent_list", Time.now.to_i
          e.add_to_index "torrent_raw_list", Time.now.to_i
        end
      end
    end
    true
  end
end
