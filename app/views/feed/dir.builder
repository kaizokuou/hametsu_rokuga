atom_feed do |feed|
  feed.title h("破滅録画作品別 - #{h @name}")
  feed.updated Time.at(@videos.first.created_at) rescue feed.updated Time.now

  @videos.each do |v|
    feed.entry(v, :url => v.url) do |entry|
      entry.title h(v.title)
      entry.content h(v.title), :type => "html"
      entry.updated v.created_at.rfc822
      entry.link :href => v.url, :title => "Podcast", :rel => "enclosure"
      entry.author do |a|
        a.name "破滅録画"
      end
    end
  end
end
