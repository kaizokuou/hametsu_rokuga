atom_feed do |feed|
  feed.title h("破滅録画 - 新着")
  feed.updated Time.now
  @es.each do |d|
    if d.index_names.index("complete_list") == nil and d.index_names.index("record_list") == nil
      feed.entry(d, :url => "http://#{request.host_with_port}/home/record?key=#{CGI.escape(d.id)}") do |entry|
        entry.title h(d.title)
        entry.content h(d.title+"を録画しますか？"), :type => "html"
        entry.updated Time.at(1278544766).rfc822 unless d.created_at
        entry.updated Time.at(d.created_at).rfc822 if d.created_at
        entry.author do |a|
          d.name "破滅録画"
        end
      end
    end
  end
end
