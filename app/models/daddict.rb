class Daddict
  D_URLs = ["http://www.d-addicts.com/forum/torrents.php?search=AKB&type=&sub=View+all&sort=","http://www.d-addicts.com/forum/torrents.php?search=Himitsu&type=jdrama&sub=sub_RAW&sort=","http://www.d-addicts.com/forum/torrents.php?search=Freeter&type=jdrama&sub=View+all&sort="]
  def self.runner
    D_URLs.each do |u|
      agent = Mechanize.new
      page = agent.get URI.parse u
      page.root.xpath("//table[(@class='forumline')]//tr").to_ary.each do |a|
        begin
          title_tag = a.children[2].children[1]
          next if title_tag.name != "a"
          title = title_tag.children.first.to_s
          url = a.children[6].children[1].attributes.to_hash["href"].to_s
          p title
          p url
          begin
            Entity.find "d-addict_title/#{CGI.escape title}"
          rescue
            e = Entity.create 'id' => "torrent/#{CGI.escape url}", 'href' => url, 'title' => title, "created_at" => Time.now.to_i
            e.add_to_index "torrent_list", Time.now.to_i
            e.add_to_index "torrent_raw_list", Time.now.to_i
            Entity.create "id" => "d-addict_title/#{CGI.escape e.title}"
          end
        rescue
        end
      end
    end
    true
  end
end
