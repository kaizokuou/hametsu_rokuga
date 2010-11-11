atom_feed do |feed|
  feed.title h("破滅録画")

  @comps.each do |d|
    feed.entry(d, :url => "http://mixi.jp/#{CGI.escape d.title}") do |entry|
      entry.title h(d.title)
      entry.content h(d.title+"が録画されました"), :type => "html"
      entry.author do |a|
        d.name "破滅録画"
      end
    end
  end
end
